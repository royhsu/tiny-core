//
//  Context.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/2/17.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - Context

/// Use context to encapsulate all associated properties and dependencies together.
/// The context provides a set of convenient methods to make instances.
/// It also throws the well-defined error when things go wrong. For examples, making instances from unregistered identifiers, or specifying a wrong target type for context to make.
public struct Context<Identifier> where Identifier: Hashable {
    
    private var storage: [Identifier: () throws -> Any] = [:]
    
    /// Register a factory for specific identifier.
    public mutating func register(
        _ factory: @escaping () throws -> Any,
        for identifier: Identifier
    ) { storage[identifier] = factory }
    
    /// Make a instance for specific identifier from the context.
    /// If the identifier hasn't been registered, the context would throw an error.
    /// Or specify the wrong target type, will also raise an error.
    public func make<T>(
        _ targetType: T.Type,
        for identifier: Identifier
    )
    throws -> T {
        
        guard let factory = storage[identifier] else { throw Error.unregistered(identifier: identifier) }
        
        let instance = try factory()
        
        guard let typedInstance = instance as? T else {
            
            throw Error.typeMismatch(
                identifier: identifier,
                expectedType: targetType,
                autualType: type(of: instance)
            )
            
        }
        
        return typedInstance
            
    }
    
}

extension Context {
    
    /// Register a factory for specific identifier.
    public mutating func register(
        _ factory: @autoclosure @escaping () throws -> Any,
        for identifier: Identifier
    ) {
        
        register(
            { try factory() },
            for: identifier
        )
        
    }
    
    public mutating func register(
        _ type: Initializable.Type,
        for identifier: Identifier
    ) {
        
        register(
            type.init,
            for: identifier
        )
        
    }
    
}

extension Context {
    
    public func make<T>(for identifier: Identifier) throws -> T {
        
        return try make(
            T.self,
            for: identifier
        )
        
    }
    
}

// MARK: - Error

extension Context {
    
    private typealias Error = ContextError<Identifier>
    
}
