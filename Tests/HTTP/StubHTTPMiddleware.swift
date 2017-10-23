//
//  StubHTTPMiddleware.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 21/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - StubHTTPMiddleware

import TinyCore

internal struct StubHTTPMiddleware: HTTPMiddleware {

    // MARK: Property

    internal let operation: (URLRequest) -> URLRequest

    // MARK: Init

    internal init(
        operation: @escaping (URLRequest) -> URLRequest
    ) {

        self.operation = operation

    }

    // MARK: HTTPClientMiddleware

    internal func respond(
        to request: URLRequest,
        completion: @escaping (_ response: HTTPResponse) -> Void
    )
    -> (request: URLRequest, completion: (HTTPResponse) -> Void) {

        let request = operation(request)

        return (request, completion)

    }

}
