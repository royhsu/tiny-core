//
//  ReducibleAction.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/3/14.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - ReducibleAction

public struct ReducibleAction<Identifier, Value> where Identifier: Hashable {
    
    public let identifier: Identifier
    
    public let handler: (
        _ currentValue: Value,
        _ newValueGenerator: @escaping (_ newValue: Value) -> Void
    )
    -> Void
    
    public init(
        identifier: Identifier,
        handler: @escaping (
            _ currentValue: Value,
            _ newValueGenerator: @escaping (_ newValue: Value) -> Void
        )
        -> Void
    ) {
    
        self.identifier = identifier
        
        self.handler = handler
        
    }
    
}
