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
        
        private final let handler: (_ change: ObservedChange<Value>) -> Void

        internal init(
            handler: @escaping (_ change: ObservedChange<Value>) -> Void
        ) { self.handler = handler }

        internal final func notify(with change: ObservedChange<Value>) { handler(change) }

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

        private final var bindings: [AnyBinding<Value>] = []

        internal final func observe(
            changeHandler: @escaping (_ change: ObservedChange<Value>) -> Void
        )
        -> Observation {

            let observation = Observer(handler: changeHandler)

            objects.append(
                WeakObject(observation)
            )

            return observation

        }

        @discardableResult
        internal final func bind<Target: AnyObject, U>(
            transform: @escaping (Value?) -> U,
            to target: Target,
            keyPath: ReferenceWritableKeyPath<Target, U>
        )
        -> AnyBinding<Value> {

            let binding = ValueBinding(
                transform: transform,
                target: target,
                keyPath: keyPath
            )

            let anyBinding = AnyBinding(binding)

            bindings.append(anyBinding)

            return anyBinding

        }

        @discardableResult
        internal final func bind<Target: AnyObject, U>(
            transform: @escaping (Value?) -> U?,
            to target: Target,
            keyPath: ReferenceWritableKeyPath<Target, U?>
        )
        -> AnyBinding<Value> {

            let binding = OptionalValueBinding(
                transform: transform,
                target: target,
                keyPath: keyPath
            )

            let anyBinding = AnyBinding(binding)

            bindings.append(anyBinding)

            return anyBinding

        }

        internal final func notifyAll(with change: ObservedChange<Value>) {

            let liveObjects = objects.filter { $0.reference != nil }

            objects = liveObjects

            let liveBindings = bindings.filter { $0.target != nil }

            bindings = liveBindings

            liveObjects.forEach { $0.reference?.notify(with: change) }

            liveBindings.forEach { $0.update(with: change.currentValue) }

        }

    }

    private let boardcaster = Broadcaster()

    public init(_ value: Value? = nil) {

        if let initialValue = value {

            self.isInitialValue = false

            self._value = initialValue

        }

    }

}

public extension Observable {

    public func observe(
        changeHandler: @escaping (_ change: ObservedChange<Value>) -> Void
    )
    -> Observation {

        return boardcaster.observe(
            changeHandler: changeHandler
        )

    }

}

public extension Observable {

    public func bind<Target: AnyObject, U>(
        transform: @escaping (Value?) -> U,
        to target: Target,
        keyPath: ReferenceWritableKeyPath<Target, U>
    ) {

        let binding = boardcaster.bind(
            transform: transform,
            to: target,
            keyPath: keyPath
        )

        binding.update(with: value)

    }

    public func bind<Target: AnyObject, U>(
        transform: @escaping (Value?) -> U?,
        to target: Target,
        keyPath: ReferenceWritableKeyPath<Target, U?>
    ) {

        let binding = boardcaster.bind(
            transform: transform,
            to: target,
            keyPath: keyPath
        )

        binding.update(with: value)

    }

    public func bind<Target: AnyObject>(
        to target: Target,
        keyPath: ReferenceWritableKeyPath<Target, Value?>
    ) {

        bind(
            transform: { $0 },
            to: target,
            keyPath: keyPath
        )

    }

}
