//
//  Future.swift
//  TinyCore
//
//  Created by Roy Hsu on 22/01/2018.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - Future

public protocol Future {
    
    @discardableResult
    func then<T, N>(
        in context: FutureContext?,
        handler: @escaping (T) throws -> N
    )
    -> Future
    
    @discardableResult
    func `catch`(
        in context: FutureContext?,
        handler: @escaping (Error) throws -> Void
    )
    -> Future
    
}

extension Future {
    
    @discardableResult
    public func then<T, N>(
        handler: @escaping (T) throws -> N
    )
    -> Future {
        
        return self.then(
            in: nil,
            handler: handler
        )
        
    }
    
    @discardableResult
    func `catch`(
        handler: @escaping (Error) throws -> Void
    )
    -> Future {
        
        return self.catch(
            in: nil,
            handler: handler
        )
        
    }
    
}
