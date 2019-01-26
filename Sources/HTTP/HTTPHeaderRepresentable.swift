//
//  HTTPHeaderRepresentable.swift
//  TinyKnowledge
//
//  Created by Roy Hsu on 2019/1/26.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - HTTPHeaderRepresentable

public protocol HTTPHeaderRepresentable {
    
    func httpHeader() throws -> (field: HTTPHeader, value: String)
    
}
