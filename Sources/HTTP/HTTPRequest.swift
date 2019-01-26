//
//  HTTPRequest.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/1/26.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - HTTPRequest

public struct HTTPRequest<Body> {
    
    public var url: URL
    
    public var headers: [HTTPHeader: String] = [:]
    
    public var method: HTTPMethod = .get
    
    public var body: Body
    
    public init(
        url: URL,
        body: Body
    ) {
        
        self.url = url
        
        self.body = body
        
    }
    
}
