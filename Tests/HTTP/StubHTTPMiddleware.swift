//
//  StubHTTPMiddleware.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 21/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - StubHTTPMiddleware

import TinyCore

internal final class StubHTTPMiddleware: HTTPMiddleware {

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
        completion: @escaping (_ response: HTTPResponse) -> Void
    )
    -> (URLRequest, (HTTPResponse) -> Void) {

        let request = operation(request)

        return (request, completion)

    }

}
