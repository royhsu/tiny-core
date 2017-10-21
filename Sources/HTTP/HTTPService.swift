//
//  HTTPService.swift
//  TinyCore
//
//  Created by Roy Hsu on 19/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - HTTPService

public protocol HTTPService: class {

    // MARK: Property

    var middlewares: [HTTPMiddleware] { get }

    var client: HTTPClient { get }

    // MARK: Request

    func request(
        _ request: URLRequest,
        completion: @escaping (_ response: HTTPResponse) -> Void
    )

}

// MARK: - Request (Default Implementation)

public extension HTTPService {

    public func request(
        _ request: URLRequest,
        completion: @escaping (_ response: HTTPResponse) -> Void
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
