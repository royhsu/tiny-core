//
//  StubHTTPClient.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 19/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - StubHTTPClient

import TinyCore

internal struct StubHTTPClient: HTTPClient {

    // MARK: Property

    internal let data: Data

    // MARK: HTTPClient

    internal func request(
        _ request: URLRequest,
        completion: @escaping (Result<Data>) -> Void) {

        completion(
            .success(data)
        )

    }

}
