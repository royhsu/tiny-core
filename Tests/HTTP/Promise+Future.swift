//
//  Promise+Future.swift
//  TinyCore
//
//  Created by Roy Hsu on 22/01/2018.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - FutureContext

extension Context: FutureContext { }

// MARK: - Future

import TinyCore

extension Promise: Future {
    
    public final func then<N>(
        in context: FutureContext? = nil,
        handler: @escaping (Value) -> N
    )
    -> Future {
        
        guard
            let context = context as? Context
        else { fatalError("Error handling.") }
  
        return self.then(
            in: context,
            handler
        )
            
    }
    
    public final func then<T, N>(
        in context: FutureContext? = nil,
        handler: @escaping (T) throws -> N
    )
    -> Future {

        return self.then(
            in: context,
            handler: handler
        )
        
    }

    public final func `catch`(
        in context: FutureContext? = nil,
        handler: @escaping (Error) throws -> Void
    )
    -> Future {
        
        guard
            let context = context as? Context
        else { fatalError("Error handling.") }
        
        return self.catch(
            in: context,
            handler
        )
        
    }
    
}
