//
//  HTTPResponse.swift
//  TinyCore
//
//  Created by Roy Hsu on 21/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - HTTPResponse

public struct HTTPResponse {
    
    // MARK: Property
    
    public let request: URLRequest
    
    public let response: URLResponse
    
    public let result: Result<Data>
    
    // MARK: Init
    
    public init(
        request: URLRequest,
        response: URLResponse,
        result: Result<Data>
    ) {
        
        self.request = request
        
        self.response = response
        
        self.result = result
        
    }
    
}
