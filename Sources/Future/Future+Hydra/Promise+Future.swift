//
//  Promise+Future.swift
//  TinyCore
//
//  Created by Roy Hsu on 22/01/2018.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

public enum PromiseFutureError: Error {
    
    case invalidContext(FutureContext)
    
    case unexpectedValueType(Any)
    
}

// MARK: - Future

extension Promise: Future {
    
    public final func then<T, N>(
        in context: FutureContext?,
        handler: @escaping (T) throws -> N
    )
    -> Future {
        
        do {
        
            let context = try sanitize(context)
            
            return self.then(in: context) { value -> N in
                
                guard
                    let targetValue = value as? T
                else {
                    
                    let valueType = type(of: value)
                    
                    let error: PromiseFutureError = .unexpectedValueType(valueType)
                    
                    throw error
                        
                }
                
                return try handler(targetValue)
                
            }
            
        }
        catch { return Promise(rejected: error) }
        
    }

    public final func `catch`(
        in context: FutureContext?,
        handler: @escaping (Error) throws -> Void
    )
    -> Future {
        
        do {
            
            let context = try sanitize(context)
        
            return self.catch(
                in: context,
                handler
            )
         
        }
        catch { return Promise(rejected: error) }
        
    }
    
    private final func sanitize(_ context: FutureContext?) throws -> Context? {
        
        if let context = context {
            
            guard
                let validContext = context as? Context
            else {
                
                let error: PromiseFutureError = .invalidContext(context)
                
                throw error
                    
            }
            
            return validContext
            
        }
        
        return nil
        
    }
    
    
}
