//
//  Property+Binding.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/2/23.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - Binding

extension Property {

    public typealias BindingDestination<Target, U> = (
        target: Target,
        keyPath: ReferenceWritableKeyPath<Target, U>
    )
    where Target: AnyObject

    public func bind<Target: AnyObject, U>(
        on queue: DispatchQueue = .main,
        transform: @escaping (Value?) -> U,
        to destination: BindingDestination<Target, U>
    )
    -> Observation {

        destination.target[keyPath: destination.keyPath] = transform(value)

        return boardcaster.observe(on: queue) { change in

            let newValue = transform(change.currentValue)

            destination.target[keyPath: destination.keyPath] = newValue

        }

    }

    public func bind<Target: AnyObject, U>(
        on queue: DispatchQueue = .main,
        transform: @escaping (Value?) -> U?,
        to destination: BindingDestination<Target, U?>
    )
    -> Observation {

        destination.target[keyPath: destination.keyPath] = transform(value)

        return boardcaster.observe(on: queue) { change in

            let newValue = transform(change.currentValue)

            destination.target[keyPath: destination.keyPath] = newValue

        }

    }

    public func bind<Target: AnyObject>(
        on queue: DispatchQueue = .main,
        to destination: BindingDestination<Target, Value?>
    )
    -> Observation {

        return bind(
            on: queue,
            transform: { $0 },
            to: destination
        )

    }

}
