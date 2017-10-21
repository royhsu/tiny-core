//
//  StubHTTPService.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 21/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - StubHTTPService

import TinyCore

internal final class StubHTTPService: HTTPService {

    // MARK: Property

    internal final let middlewares: [HTTPMiddleware]

    internal final let client: HTTPClient

    // MARK: Init

    internal init(
        middlewares: [HTTPMiddleware],
        client: HTTPClient
    ) {

        self.middlewares = middlewares

        self.client = client

    }

}
