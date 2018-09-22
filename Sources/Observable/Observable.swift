//
//  Observable.swift
//  TinyCore
//
//  Created by Roy Hsu on 17/03/2018.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - Observable

public struct Observable<Value> {
    
    private final class _Observation: Observation {
        
        internal final let observer: (_ change: ObservedChange<Value>) -> Void
        
        internal init(
            observer: @escaping (_ change: ObservedChange<Value>) -> Void
        ) { self.observer = observer }
        
    }
    
    private var isInitialValue = true
    
    private var _value: Value? {
        
        willSet {
            
            if !isInitialValue { isInitialValue.toggle() }
            
        }
        
    }
    
    public var value: Value? {
        
        get { return _value }
        
        set { setValue(newValue) }
        
    }
    
    public mutating func setValue(_ newValue: Value?) {
        
        let oldValue = value
        
        _value = newValue
        
        let change: ObservedChange<Value> =
            self.isInitialValue
            ? .initial(newValue: newValue)
            : .changed(
                newValue: newValue,
                oldValue: oldValue
            )
        
        self.boardcaster.notifyAll(with: change)
        
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
            
            // Clean up the dead objects.
            objects.removeAll { $0.reference == nil }
            
            objects.forEach { $0.reference?.observer(change) }
            
        }
        
    }
    
    private var boardcaster = Broadcaster()

    public init() { }
    
    public mutating func observe(
        observer: @escaping (_ change: ObservedChange<Value>) -> Void
    )
    -> Observation { return boardcaster.addObserver(observer) }
    
}
