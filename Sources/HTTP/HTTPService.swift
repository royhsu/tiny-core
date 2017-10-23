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

    var client: HTTPClient { get }

    // MARK: Request

    func request(
        _ request: URLRequest,
        middlewares: [HTTPMiddleware],
        completion: @escaping (_ response: HTTPResponse) -> Void
    )

}

// MARK: - Request (Default Implementation)

public extension HTTPService {

    // Todo: (version: nil, priority: .high)
    // 1. The currently default implementation makes middlewares hard to do async tasks.
    //    May use semaphore to convert async tasks to sync ones for doing the trick.
    // Should do some research for a better implementation.
    public func request(
        _ request: URLRequest,
        middlewares: [HTTPMiddleware],
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
