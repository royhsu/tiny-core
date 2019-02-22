//
//  Property.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/1/18.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - Property

public final class Property<Value> {

    private let boardcaster = Broadcaster()

    private var isInitialValue = true
    
    private let _storage: Atomic<Value?>

    public init(value: Value? = nil) {

        if let initialValue = value {

            self._storage = Atomic(value: initialValue)

            self.isInitialValue = false

        }
        else { self._storage = Atomic(value: nil) }

    }
    
}

extension Property {

    public func mutateValue(
        _ mutation: @escaping (inout Value?) -> Void
    ) {

        _storage.mutateValue { value in

            let oldValue = value

            mutation(&value)

            let newValue = value

            let change: ObservedChange =
                self.isInitialValue
                ? .initial(value: newValue)
                : .changed(
                    oldValue: oldValue,
                    newValue: newValue
                )

            if self.isInitialValue { self.isInitialValue = false }

            self.boardcaster.notifyAll(with: change)

        }

    }

}

// MARK: - Observable

extension Property: Observable {
    
    public var value: Value? { return _storage.value }

    public func observe(
        on queue: DispatchQueue = .global(),
        observer: @escaping (ObservedChange) -> Void
    )
    -> Observation {

        return boardcaster.observe(
            on: queue,
            observer: observer
        )

    }

}

// MARK: - Observer

internal extension Property {

    private final class PropertyObservation: Observation {

        private let queue: DispatchQueue

        private let observer: (ObservedChange) -> Void

        init(
            queue: DispatchQueue,
            observer: @escaping (ObservedChange) -> Void
        ) {

            self.queue = queue

            self.observer = observer

        }

        func notify(with change: ObservedChange) {

            queue.async { [weak self] in

                guard let self = self else { return }

                self.observer(change)

            }

        }

    }

}

// MARK: - Binding

public extension Property {

    public typealias BindingDestination<Target, U> = (
        target: Target,
        keyPath: ReferenceWritableKeyPath<Target, U>
    )
    where Target: AnyObject

    public func bind<Target: AnyObject, U>(
        on queue: DispatchQueue = .main,
        transform: @escaping (Value?) -> U,
        to destination: BindingDestination<Target, U>
    ) {

        let binding = boardcaster.bind(
            on: queue,
            transform: transform,
            to: destination
        )

        binding.update(with: value)

    }

    public func bind<Target: AnyObject, U>(
        on queue: DispatchQueue = .main,
        transform: @escaping (Value?) -> U?,
        to destination: BindingDestination<Target, U?>
    ) {

        let binding = boardcaster.bind(
            on: queue,
            transform: transform,
            to: destination
        )

        binding.update(with: value)

    }

    public func bind<Target: AnyObject>(
        on queue: DispatchQueue = .main,
        to destination: BindingDestination<Target, Value?>
    ) {

        bind(
            on: queue,
            transform: { $0 },
            to: destination
        )

    }

}

// MARK: - Broadcaster

internal extension Property {

    private final class Broadcaster {

        typealias Object = WeakObject<PropertyObservation>

        private var objects: [Object] = []

        private var bindings: [AnyBinding<Value>] = []

        func observe(
            on queue: DispatchQueue,
            observer: @escaping (ObservedChange) -> Void
        )
        -> Observation {

            let observation = PropertyObservation(
                queue: queue,
                observer: observer
            )

            objects.append(
                WeakObject(observation)
            )

            return observation

        }

        @discardableResult
        func bind<Target: AnyObject, U>(
            on queue: DispatchQueue,
            transform: @escaping (Value?) -> U,
            to destination: BindingDestination<Target, U>
        )
        -> AnyBinding<Value> {

            let binding = ValueBinding(
                queue: queue,
                transform: transform,
                target: destination.target,
                keyPath: destination.keyPath
            )

            let anyBinding = AnyBinding(binding)

            bindings.append(anyBinding)

            return anyBinding

        }

        @discardableResult
        func bind<Target: AnyObject, U>(
            transform: @escaping (Value?) -> U?,
            to destination: BindingDestination<Target, U?>,
            queue: DispatchQueue
        )
        -> AnyBinding<Value> {

            let binding = OptionalValueBinding(
                queue: queue,
                transform: transform,
                target: destination.target,
                keyPath: destination.keyPath
            )

            let anyBinding = AnyBinding(binding)

            bindings.append(anyBinding)

            return anyBinding

        }

        func notifyAll(with change: ObservedChange) {

            let liveBindings = bindings.filter { $0.target != nil }

            bindings = liveBindings

            // Bindings must happen before observers.
            liveBindings.forEach { $0.update(with: change.currentValue) }

            let liveObjects = objects.filter { $0.reference != nil }

            objects = liveObjects

            liveObjects.forEach { $0.reference?.notify(with: change) }

        }

    }

}
