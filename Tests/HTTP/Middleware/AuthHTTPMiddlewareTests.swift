//
//  AuthHTTPMiddlewareTests.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 21/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

internal struct StubAuthManager: AuthDelegate {
    
    internal let auth: Auth?
    
    internal init(auth: Auth?) {
        
        self.auth = auth
        
    }
    
    internal func authorize(completion: (Result<Auth>) -> Void) {
        
        fatalError()
        
    }
    
}

// MARK: - AuthHTTPMiddlewareTests

import XCTest

@testable import TinyCore

internal final class AuthHTTPMiddlewareTests: XCTestCase {
    
    internal final func testMiddleware() {
        
        let promise = expectation(description: "Run the auth middleware.")
        
        // Todo: (version: 0.4.0, priority: .high)
        // 1. find a name that doesn't conflict to the native type 'Data'.
        struct Data {
            
            let accessToken: AccessTokenCredentials
            
        }
        
        let data = Data(
            accessToken: AccessTokenCredentials(
                grantType: .jwt,
                token: "abcd1234"
            )
        )
        
        performTest {
            
            let middleware = AuthHTTPMiddleware(
                authDelegate: StubAuthManager(
                    auth: Auth(
                        credentials: data.accessToken,
                        provider: StubPasswordAuthProvider(
                            result: .success(data.accessToken)
                        )
                    )
                )
            )
            
            let url = try unwrap(
                URL(string: "http://api.foo.com")
            )
            
            let request = URLRequest(url: url)
            
            let result = middleware.respond(
                to: request,
                completion: { response in
                    
                    promise.fulfill()
                    
                    let authorizationHeader = response.request.value(forHTTPHeaderField: "Authorization")
                    
                    XCTAssertEqual(
                        authorizationHeader,
                        "Bearer \(data.accessToken.token)"
                    )
                    
                }
            )
            
            result.completion(
                HTTPResponse(
                    request: result.request,
                    response: URLResponse(),
                    result: .success(.init())
                )
            )
            
        }
        
        wait(
            for: [ promise ],
            timeout: 10.0
        )
        
    }
    
}
