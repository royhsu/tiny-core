//
//  APIService.swift
//  TinyCore
//
//  Created by Roy Hsu on 19/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - APIService

public struct APIService {

    // MARK: Property

    public let auth: Auth?

    public let client: HTTPClient

}

// MARK: - HTTPService

public final class HTTPService {
    
    // MARK: Property
    
    public let middlewares: [HTTPClientMiddleware]
    
    public let client: HTTPClient
    
    // MARK: Init
    
    public init(
        middlewares: [HTTPClientMiddleware],
        client: HTTPClient
    ) {
        
        self.middlewares = middlewares
        
        self.client = client
        
    }
    
}

// MARK: - Request

public extension HTTPService {
    
    public final func request(
        _ request: URLRequest,
        completion: @escaping (_ result: Result<Data>) -> Void
    ) {
        
        let initialResult = (request: request, completion: completion)
        
        let finalResult = middlewares.reduce(initialResult) { currentResult, middleware in
            
            let nextResult = middleware.respond(
                to: currentResult.request,
                completion: currentResult.completion
            )
            
            return nextResult
            
        }
        
        client.request(
            finalResult.request,
            completion: finalResult.completion
        )
        
    }
    
}
