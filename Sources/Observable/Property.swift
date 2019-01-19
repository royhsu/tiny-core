//
//  Property.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/1/18.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - Property

public final class Property<Value> {
    
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
    public final func mutateValue(
        _ setter: @escaping (inout Value?) -> ()
    ) {
        
        atomic.mutateValue { value in
            
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
        
        private final let queue: DispatchQueue
        
        private final let observer: (ObservedChange) -> Void
        
        internal init(
            queue: DispatchQueue,
            observer: @escaping (ObservedChange) -> Void
        ) {
            
            self.queue = queue
            
            self.observer = observer
            
        }
        
        internal final func notify(with change: ObservedChange) {
            
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
    
    public final func bind<Target: AnyObject, U>(
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
    
    public final func bind<Target: AnyObject, U>(
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
    
    public final func bind<Target: AnyObject>(
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
        
        internal typealias Object = WeakObject<PropertyObservation>
        
        private final var objects: [Object] = []
        
        private final var bindings: [AnyBinding<Value>] = []
        
        internal final func observe(
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
        internal final func bind<Target: AnyObject, U>(
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
        internal final func bind<Target: AnyObject, U>(
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
        
        internal final func notifyAll(with change: ObservedChange) {
            
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
