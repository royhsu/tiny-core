//
//  ObservedChange.swift
//  TinyCore
//
//  Created by Roy Hsu on 2018/9/11.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - ObservedChange

public enum ObservedChange<Value> {
    
    case initial(value: Value)
    
    case changed(oldValue: Value, newValue: Value)
    
    public var currentValue: Value {
        
        switch self {
            
        case let .initial(value): return value
            
        case let .changed(_, newValue): return newValue
            
        }
        
    }
    
}
