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

    internal final let middlewares: [HTTPClientMiddleware]

    internal final let client: HTTPClient

    // MARK: Init

    internal init(
        middlewares: [HTTPClientMiddleware],
        client: HTTPClient
    ) {

        self.middlewares = middlewares

        self.client = client

    }

}
