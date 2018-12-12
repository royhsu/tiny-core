//
//  Observable.swift
//  TinyCore
//
//  Created by Roy Hsu on 17/03/2018.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - Observable

public struct Observable<Value> {

    private final class Observer: Observation {

        private final let queue: DispatchQueue
        
        private final let handler: (_ change: ObservedChange<Value>) -> Void

        internal init(
            queue: DispatchQueue,
            handler: @escaping (_ change: ObservedChange<Value>) -> Void
        ) {
            
            self.queue = queue
            
            self.handler = handler
            
        }
        
        internal final func notify(with change: ObservedChange<Value>) {
            
            queue.async { [weak self] in self?.handler(change) }
            
        }

    }

    private var isInitialValue = true

    private var _value: Value?

    public var value: Value? {

        get { return _value }

        set {

            let oldValue = _value

            _value = newValue

            let change: ObservedChange<Value> =
                isInitialValue
                ? .initial(value: newValue)
                : .changed(
                    oldValue: oldValue,
                    newValue: newValue
                )

            if isInitialValue { isInitialValue = false }

            boardcaster.notifyAll(with: change)
            
        }

    }

    private final class Broadcaster {

        internal typealias Object = WeakObject<Observer>

        private final var objects: [Object] = []

        internal final func addObserver(
            on queue: DispatchQueue,
            changeHandler: @escaping (_ change: ObservedChange<Value>) -> Void
        )
        -> Observation {

            let observation = Observer(
                queue: queue,
                handler: changeHandler
            )

            objects.append(
                WeakObject(observation)
            )

            return observation

        }

        internal final func notifyAll(with change: ObservedChange<Value>) {

            let liveObjects = objects.filter { $0.reference != nil }

            objects = liveObjects

            liveObjects.forEach { $0.reference?.notify(with: change) }

        }

    }

    private let boardcaster = Broadcaster()

    public init(_ value: Value? = nil) {

        if let initialValue = value {

            self.isInitialValue = false

            self._value = initialValue

        }

    }

    public mutating func observe(
        on queue: DispatchQueue = .global(),
        changeHandler: @escaping (_ change: ObservedChange<Value>) -> Void
    )
    -> Observation {
        
        return boardcaster.addObserver(
            on: queue,
            changeHandler: changeHandler
        )
        
    }

}
