//
//  AuthHTTPMiddleware.swift
//  TinyCore
//
//  Created by Roy Hsu on 21/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - AuthHTTPMiddleware

public struct AuthHTTPMiddleware: HTTPMiddleware {
    
    // MARK: Property
    
    public let authDelegate: AuthDelegate
    
    // MARK: Init
    
    public init(authDelegate: AuthDelegate) {
        
        self.authDelegate = authDelegate
        
    }
    
    // MARK: HTTPMiddleware
    
    public func respond(
        to request: URLRequest,
        completion: @escaping (_ response: HTTPResponse) -> Void
    )
    -> (request: URLRequest, completion: (HTTPResponse) -> Void) {
        
        guard
            let auth = authDelegate.auth
        else {
       
            let newCompletion: (HTTPResponse) -> Void = { originalResponse in
                
                let error = AuthError.unauthorized
                
                let newResponse = HTTPResponse(
                    request: originalResponse.request,
                    response: HTTPURLResponse(
                        url: originalResponse.request.url!,
                        statusCode: error.statusCode,
                        httpVersion: nil,
                        headerFields: nil
                    )!,
                    result: .failure(error)
                )
                
                completion(newResponse)
                
            }
            
            return (request, newCompletion)
            
        }
        
        var request = request
        
        switch auth.credentials.grantType {
            
        case .password:
            
            guard
                let credentials = auth.credentials as? PasswordCredentials,
                let data = "\(credentials.username):\(credentials.password)".data(using: .utf8)
            else {
                
                // Todo: (version: 0.4.0, priority: .high)
                // 1. error handling.
                
                fatalError()
                    
            }
            
            let value = data.base64EncodedString()
            
            request.setValue(
                "Basic \(value)",
                forHTTPHeaderField: "Authorization"
            )
            
        case .jwt:
            
            guard
                let credentials = auth.credentials as? AccessTokenCredentials
            else {
                
                // Todo: (version: 0.4.0, priority: .high)
                // 1. error handling.
                
                fatalError()
                    
            }
            
            request.setValue(
                "Bearer \(credentials.token)",
                forHTTPHeaderField: "Authorization"
            )
            
        }
        
        return (request, completion)
        
    }
    
}
