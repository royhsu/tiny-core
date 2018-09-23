//
//  Unique.swift
//  TinyCore
//
//  Created by Roy Hsu on 2018/9/22.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - Unique

public protocol Unique {
    
    associatedtype Identifier: Hashable
    
    var identifier: Identifier { get }
    
}
