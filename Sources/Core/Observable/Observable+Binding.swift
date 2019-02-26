//
//  Property+Binding.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/2/23.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - Binding

extension Observable {
    
    public typealias Value = ObservedChange.Value

    public func bind<Target: AnyObject, U>(
        on queue: DispatchQueue = .main,
        transform: @escaping (Value?) -> U,
        to destination: (target: Target, keyPath: ReferenceWritableKeyPath<Target, U>)
    )
    -> Observation {

        destination.target[keyPath: destination.keyPath] = transform(value)

        return observe(on: queue) { change in

            let newValue = transform(change.currentValue)

            destination.target[keyPath: destination.keyPath] = newValue

        }

    }

    public func bind<Target: AnyObject, U>(
        on queue: DispatchQueue = .main,
        transform: @escaping (Value?) -> U?,
        to destination: (target: Target, keyPath: ReferenceWritableKeyPath<Target, U?>)
    )
    -> Observation {

        destination.target[keyPath: destination.keyPath] = transform(value)

        return observe(on: queue) { change in

            let newValue = transform(change.currentValue)

            destination.target[keyPath: destination.keyPath] = newValue

        }

    }

    public func bind<Target: AnyObject>(
        on queue: DispatchQueue = .main,
        to destination: (target: Target, keyPath: ReferenceWritableKeyPath<Target, Value?>)
    )
    -> Observation {

        return bind(
            on: queue,
            transform: { $0 },
            to: destination
        )

    }
    
    public func bind<Target: AnyObject, U>(
        on queue: DispatchQueue = .main,
        transform: @escaping (Value?) -> U,
        to destination: (target: Target?, keyPath: ReferenceWritableKeyPath<Target?, U>)
    )
    -> Observation {
        
        destination.target?[keyPath: destination.keyPath] = transform(value)
        
        return observe(on: queue) { change in
            
            let newValue = transform(change.currentValue)
            
            destination.target?[keyPath: destination.keyPath] = newValue
            
        }
        
    }
    
    public func bind<Target: AnyObject, U>(
        on queue: DispatchQueue = .main,
        transform: @escaping (Value?) -> U?,
        to destination: (target: Target?, keyPath: ReferenceWritableKeyPath<Target?, U?>)
    )
    -> Observation {
        
        destination.target?[keyPath: destination.keyPath] = transform(value)
        
        return observe(on: queue) { change in
            
            let newValue = transform(change.currentValue)
            
            destination.target?[keyPath: destination.keyPath] = newValue
            
        }
            
    }
    
    public func bind<Target: AnyObject>(
        on queue: DispatchQueue = .main,
        to destination: (target: Target?, keyPath: ReferenceWritableKeyPath<Target?, Value?>)
    )
    -> Observation {
        
        return bind(
            on: queue,
            transform: { $0 },
            to: destination
        )
            
    }

}
