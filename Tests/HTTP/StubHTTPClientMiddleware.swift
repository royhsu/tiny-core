//
//  StubHTTPClientMiddleware.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 21/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - StubHTTPClientMiddleware

import TinyCore

internal final class StubHTTPClientMiddleware: HTTPClientMiddleware {
    
    // MARK: Property
    
    internal final let operation: (URLRequest) -> URLRequest
    
    // MARK: Init
    
    internal init(
        operation: @escaping (URLRequest) -> URLRequest
    ) {
        
        self.operation = operation
        
    }
    
    // MARK: HTTPClientMiddleware
    
    internal final func respond(
        to request: URLRequest,
        completion: @escaping (Result<Data>) -> Void)
        -> (URLRequest, (Result<Data>) -> Void) {
        
        let request = operation(request)
            
        return (request, completion)
            
    }
    
}
