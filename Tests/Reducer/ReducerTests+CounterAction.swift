//
//  ReducerTests+CounterAction.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 2019/3/14.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - CounterAction

import TinyCore

extension ReducerTests {
    
    enum CounterAction {
        
        case increment(
            identifier: String,
            number: Int,
            willBegin: (Counter) -> Void,
            didEnd: (Counter) -> Void
        )
        
        case decrement(
            identifier: String,
            number: Int,
            willBegin: (Counter) -> Void,
            didEnd: (Counter) -> Void
        )
        
        var identifier: String {
            
            switch self {
                
            case let .increment(identifier, _, _, _): return identifier
                
            case let .decrement(identifier, _, _, _): return identifier
                
            }
            
        }
        
        var action: ReducibleAction<String, Counter> {
            
            switch self {
                
            case let .increment(identifier, number, willBegin, didEnd):
                
                return ReducibleAction(identifier: identifier) { currentCounter, handler in
                    
                    willBegin(currentCounter)
                    
                    var nextCounter = currentCounter
                    
                    nextCounter.currentNumber += number
                    
                    didEnd(nextCounter)
                    
                    handler(nextCounter)
                    
                }
                
            case let .decrement(identifier, number, willBegin, didEnd):
                
                return ReducibleAction(identifier: identifier) { currentCounter, handler in
                    
                    willBegin(currentCounter)
                    
                    var nextCounter = currentCounter
                    
                    nextCounter.currentNumber -= number
                    
                    didEnd(nextCounter)
                    
                    handler(nextCounter)
                    
                }
                
            }
            
        }
        
    }
    
}
