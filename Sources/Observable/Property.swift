//
//  Property.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/1/18.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - Property

public final class Property<Value> {
    
    private final let queue: DispatchQueue = {
        
        let id = UUID()
        
        let module = String(describing: Property.self)
        
        return DispatchQueue(label: "\(module).SerialQueue.\(id)", attributes: .concurrent)
        
    }()
    
    private final let boardcaster = Broadcaster()
    
    private final let atomic = Atomic<Value?>(value: nil)
    
    private final var isInitialValue = true
    
    public init() { }
    
}

// MARK: - Atomic

public extension Property {
    
    /// A property will ensure to finish the previous writing operation before reading the underlying value.
    public final var value: Value? { return atomic.value }
    
    /// Setting value is the asynchronized operation to avoid blocking the calling thread.
    public final func setValue(
        _ setter: @escaping (inout Value?) -> ()
    ) {
        
        atomic.setValue { value in
            
            let oldValue = value
            
            setter(&value)
            
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

// MARK: - Equatable

extension Property: Equatable where Value: Equatable {
    
    public static func == (
        lhs: Property<Value>,
        rhs: Property<Value>
    )
    -> Bool { return lhs.value == rhs.value }
    
}

// MARK: - Observable

extension Property: ObservableProtocol {
    
    public final func observe(
        _ observer: @escaping (ObservedChange) -> Void
    )
    -> Observation { return boardcaster.observe(observer) }
    
}

public extension Property {
    
    public enum ObservedChange: ObservedChangeProtocol {
        
        case initial(value: Value?)
        
        case changed(
            oldValue: Value?,
            newValue: Value?
        )
        
        public var currentValue: Value? {
            
            switch self {
                
            case let .initial(value): return value
                
            case let .changed(_, newValue): return newValue
                
            }
            
        }
        
    }
    
}

// MARK: - Observer

internal extension Property {
    
    private final class PropertyObservation: Observation {
        
        private final let observer: (ObservedChange) -> Void
        
        internal init(
            observer: @escaping (ObservedChange) -> Void
        ) { self.observer = observer }
        
        internal final func notify(with change: ObservedChange) { observer(change) }
        
    }
    
}

// MARK: - Binding

public extension Property {
    
    public typealias BindingDestination<Target, U> = (
        target: Target,
        keyPath: ReferenceWritableKeyPath<Target, U>
    )
    where Target: AnyObject
    
    public final func bind<Target: AnyObject, U>(
        transform: @escaping (Value?) -> U,
        to destination: BindingDestination<Target, U>
    ) {
        
        let binding = boardcaster.bind(
            transform: transform,
            to: destination
        )
        
        binding.update(with: value)
        
    }
    
    public final func bind<Target: AnyObject, U>(
        transform: @escaping (Value?) -> U?,
        to destination: BindingDestination<Target, U?>
    ) {
        
        let binding = boardcaster.bind(
            transform: transform,
            to: destination
        )
        
        binding.update(with: value)
        
    }
    
    public final func bind<Target: AnyObject>(to destination: BindingDestination<Target, Value?>) {
        
        bind(
            transform: { $0 },
            to: destination
        )
        
    }
    
}

// MARK: - Broadcaster

internal extension Property {
    
    private final class Broadcaster {
        
        internal typealias Object = WeakObject<PropertyObservation>
        
        private final var objects: [Object] = []
        
        private final var bindings: [AnyBinding<Value>] = []
        
        internal final func observe(
            _ observer: @escaping (ObservedChange) -> Void
        )
        -> Observation {
            
            let observation = PropertyObservation(observer: observer)
            
            objects.append(
                WeakObject(observation)
            )
            
            return observation
                
        }
        
        @discardableResult
        internal final func bind<Target: AnyObject, U>(
            transform: @escaping (Value?) -> U,
            to destination: BindingDestination<Target, U>
        )
        -> AnyBinding<Value> {
                
            let binding = ValueBinding(
                transform: transform,
                target: destination.target,
                keyPath: destination.keyPath
            )
            
            let anyBinding = AnyBinding(binding)
            
            bindings.append(anyBinding)
            
            return anyBinding
                
        }
        
        @discardableResult
        internal final func bind<Target: AnyObject, U>(
            transform: @escaping (Value?) -> U?,
            to destination: BindingDestination<Target, U?>
        )
        -> AnyBinding<Value> {
            
            let binding = OptionalValueBinding(
                transform: transform,
                target: destination.target,
                keyPath: destination.keyPath
            )
            
            let anyBinding = AnyBinding(binding)
            
            bindings.append(anyBinding)
            
            return anyBinding
                
        }
        
        internal final func notifyAll(with change: ObservedChange) {
            
            let liveObjects = objects.filter { $0.reference != nil }
            
            objects = liveObjects
            
            let liveBindings = bindings.filter { $0.target != nil }
            
            bindings = liveBindings
            
            liveObjects.forEach { $0.reference?.notify(with: change) }
            
            liveBindings.forEach { $0.update(with: change.currentValue) }
            
        }
        
    }
    
}
