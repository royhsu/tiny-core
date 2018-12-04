//
//  Observable.swift
//  TinyCore
//
//  Created by Roy Hsu on 17/03/2018.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - Observable

public final class Observable<Value>: ObservableProtocol {

    private final class _Observation: Observation {

        internal final let observer: (_ change: ObservedChange<Value>) -> Void

        internal init(
            observer: @escaping (_ change: ObservedChange<Value>) -> Void
        ) { self.observer = observer }

    }

    private final var isInitialValue = true

    private final var _value: Value?

    public final var value: Value? {

        get { return _value }

        set { setValue(newValue) }

    }

    fileprivate final func setValue(_ newValue: Value?) {

        let oldValue = value

        _value = newValue

        let change: ObservedChange<Value> =
            isInitialValue
            ? .initial(value: newValue)
            : .changed(
                oldValue: oldValue,
                newValue: newValue
            )

        if isInitialValue { isInitialValue.toggle() }

        DispatchQueue.global().async {

            self.boardcaster.notifyAll(with: change)

        }

    }

    private struct Broadcaster {

        internal typealias Object = WeakObject<_Observation>

        private var objects: [Object] = []

        internal mutating func addObserver(
            _ observer: @escaping (_ change: ObservedChange<Value>) -> Void
        )
        -> Observation {

            let observation = _Observation(observer: observer)

            objects.append(
                WeakObject(observation)
            )

            return observation

        }

        internal mutating func notifyAll(with change: ObservedChange<Value>) {

            let liveObjects = objects.filter { $0.reference != nil }

            objects = liveObjects

            liveObjects.forEach { $0.reference?.observer(change) }

        }

    }

    private final var boardcaster = Broadcaster()

    public init(_ value: Value? = nil) {

        if let initialValue = value {

            self.isInitialValue = false

            self._value = initialValue

        }

    }

    public final func observe(
        _ observer: @escaping (_ change: ObservedChange<Value>) -> Void
    )
    -> Observation { return boardcaster.addObserver(observer) }

}
