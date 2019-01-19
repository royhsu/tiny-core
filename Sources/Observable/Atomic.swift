//
//  Atomic.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/1/18.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - Atomic

public final class Atomic<Value> {
    
    private final lazy var queue: DispatchQueue = {
        
        let id = UUID()
        
        let dynamicType = String(
            describing: type(of: self)
        )
    
        return DispatchQueue(
            label: "\(dynamicType).ConcurrentQueue.\(id)",
            attributes: .concurrent
        )
        
    }()
    
    private final var _value: Value
    
    public init(value: Value) { self._value = value }
    
}

public extension Atomic {
    
    /// The atomic will ensure to finish the previous writing operation before reading the underlying value.
    public final var value: Value { return queue.sync { self._value } }
    
    /// Mutating the underlying value is an asynchronous operation so it can avoid blocking the calling thread.
    public final func mutateValue(
        _ setter: @escaping (inout Value) -> ()
    ) { queue.async(flags: .barrier) { setter(&self._value) } }
    
}
