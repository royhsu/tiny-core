//
//  StubHTTPClient.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 19/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - StubHTTPClient

import TinyCore

internal final class StubHTTPClient: HTTPClient {

    // MARK: Property

    internal final let stubData: Data

    // MARK: Init

    internal init(stubData: Data) {

        self.stubData = stubData

    }

    // MARK: HTTPClient

    internal final func request(
        _ request: URLRequest,
        completion: @escaping (_ response: HTTPResponse) -> Void
    ) {

        let response = HTTPResponse(
            request: request,
            response: URLResponse(),
            result: .success(stubData)
        )

        completion(response)

    }

}
