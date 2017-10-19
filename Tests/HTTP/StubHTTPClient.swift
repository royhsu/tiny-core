//
//  StubHTTPClient.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 19/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - StubHTTPClient

import TinyCore
import Foundation

internal struct StubHTTPClient: HTTPClient {

    internal typealias Value = Data

    // MARK: Property

    internal let value: Value

    // MARK: HTTPClient

    internal func request(
        _ request: URLRequest,
        completion: @escaping (HTTPResult<Value>) -> Void) {

        completion(
            .success(value)
        )

    }

}
