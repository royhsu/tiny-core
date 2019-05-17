//
//  Observable+Map.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/5/17.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - Map

extension Observable {
    
    public func map<T>(
        _ transform: @escaping (Value) -> T
    )
    -> AnyObservable<T> {
        
        let mapper = ObservableMapper(source: self, transform: transform)
        
        return AnyObservable(mapper)
            
    }
    
}
