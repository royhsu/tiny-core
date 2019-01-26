//
//  URLRequestRepresentable.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/1/26.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - URLRequestRepresentable

public protocol URLRequestRepresentable {
    
    func urlRequest() throws -> URLRequest
    
}
