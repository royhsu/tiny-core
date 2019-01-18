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
    
    private final var _value: Value?
    
    private final var isInitialValue = true
    
    public init() { }
    
    /// A property will ensure to finish the previous writing operation before reading the underlying value.
    public final var value: Value? { return queue.sync { self._value } }
    
    /// Setting value is the asynchronized operation to avoid blocking the calling thread.
    public final func setValue(
        _ setter: @escaping (inout Value?) -> ()
    ) {
        
        queue.async(flags: .barrier) {
            
            let oldValue = self._value
            
            setter(&self._value)
            
            let newValue = self._value
            
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
    
    private final class _Observation: Observation {
        
        private final let observer: (ObservedChange) -> Void
        
        internal init(
            observer: @escaping (ObservedChange) -> Void
        ) { self.observer = observer }
        
        internal final func notify(with change: ObservedChange) { observer(change) }
        
    }
    
}

// MARK: - Broadcaster

internal extension Property {
    
    private final class Broadcaster {
        
        internal typealias Object = WeakObject<_Observation>
        
        private final var objects: [Object] = []
        
        private final var bindings: [AnyBinding<Value>] = []
        
        internal final func observe(
            _ observer: @escaping (ObservedChange) -> Void
        )
        -> Observation {
            
            let observation = _Observation(observer: observer)
            
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
