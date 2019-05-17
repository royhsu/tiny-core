//
//  Observable.swift
//  TinyCore
//
//  Created by Roy Hsu on 17/03/2018.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - Observable

public protocol Observable {

    associatedtype Value

    var value: Value { get }

    func observe(
        on queue: DispatchQueue,
        observer: @escaping (ObservedChange<Value>) -> Void
    )
    -> Observation

}

extension Observable {
    
    public func observe(
        observer: @escaping (ObservedChange<Value>) -> Void
    )
    -> Observation {
        
        return observe(on: .global(), observer: observer)
            
    }
    
}
