//
//  ObservableEvent.swift
//  TinyCore
//
//  Created by Roy Hsu on 2018/9/11.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - ObservableEvent

public enum ObservableEvent<Value> {
    
    case initial(newValue: Value?)
    
    case changed(
        newValue: Value?,
        oldValue: Value?
    )
    
    public var currentValue: Value? {
        
        switch self {
            
        case let .initial(newValue): return newValue
            
        case let .changed(newValue, _): return newValue
            
        }
        
    }
    
}
