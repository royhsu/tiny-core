//
//  Promise+Future.swift
//  TinyCore
//
//  Created by Roy Hsu on 22/01/2018.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - Future

extension Promise: Future {
    
    public final func then<T, N>(
        in context: FutureContext?,
        handler: @escaping (T) throws -> N
    )
    -> Future {
        
        let context = context as? Context
        
        return self.then(in: context) { value in
            
            return try handler(value as! T)
            
        }
        
    }

    public final func `catch`(
        in context: FutureContext?,
        handler: @escaping (Error) throws -> Void
    )
    -> Future {
        
        let context = context as? Context
        
        return self.catch(
            in: context,
            handler
        )
        
    }
    
}
