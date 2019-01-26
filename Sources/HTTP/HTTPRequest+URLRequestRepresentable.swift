//
//  HTTPRequest+URLRequestRepresentable.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/1/26.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - URLRequestRepresentable

extension HTTPRequest: URLRequestRepresentable {
    
    public func urlRequest() throws -> URLRequest {
        
        var request = URLRequest(url: url)
        
        request.httpMethod = method.rawValue
        
        request.setHTTPHeaders(headers)
        
        return request
        
    }
    
}
