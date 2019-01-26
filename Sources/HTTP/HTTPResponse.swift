//
//  HTTPResponse.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/1/26.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - HTTPResponse

public struct HTTPResponse<Body> {
    
    public let body: Body
    
    public let urlResponse: URLResponse
    
    public init(
        body: Body,
        urlResponse: URLResponse
    ) {
        
        self.body = body
        
        self.urlResponse = urlResponse
        
    }
    
}
