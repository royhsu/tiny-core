//
//  AnyObservable.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/2/22.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - AnyObservable

public struct AnyObservable<ObservedChange> where ObservedChange: ObservedChangeProtocol {
    
    private let _getter: () -> ObservedChange.Value?
    
    private let _observe: (
        _ queue: DispatchQueue,
        _ observer: @escaping (ObservedChange) -> Void
    )
    -> Observation
    
    public init<O>(_ observable: O)
    where
        O: Observable,
        O.ObservedChange == ObservedChange {
        
        self._getter = { observable.value }
        
        self._observe = observable.observe
            
    }
    
}

// MARK: - Observable

extension AnyObservable: Observable {
    
    public var value: ObservedChange.Value? { return _getter() }
    
    public func observe(
        on queue: DispatchQueue = .global(),
        observer: @escaping (ObservedChange) -> Void
    )
    -> Observation {
     
        return _observe(
            queue,
            observer
        )
        
    }
    
}
