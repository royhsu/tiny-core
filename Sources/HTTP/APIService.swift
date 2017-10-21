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

public protocol HTTPService: class {
    
    // MARK: Property
    
    var middlewares: [HTTPClientMiddleware] { get }
    
    var client: HTTPClient { get }
    
    // MARK: Request
    
    func request(
        _ request: URLRequest,
        completion: @escaping (_ result: Result<Data>) -> Void
    )
    
}

// MARK: - Request (Default Implementation)

public extension HTTPService {
    
    public func request(
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
