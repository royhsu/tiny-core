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

    internal final let data: Data
    
    // MARK: Init
    
    internal init(data: Data) {
        
        self.data = data
        
    }

    // MARK: HTTPClient

    internal final func request(
        _ request: URLRequest,
        completion: @escaping (Result<Data>) -> Void) {

        completion(
            .success(data)
        )

    }

}
