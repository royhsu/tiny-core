//
//  AuthHTTPMiddlewareTests.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 21/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - AuthHTTPMiddlewareTests

import XCTest

@testable import TinyCore

internal final class AuthHTTPMiddlewareTests: XCTestCase {
    
    // MARK: Middleware
    
    internal final func testMiddleware() {
        
        let promise = expectation(description: "Run the auth middleware.")
        
        struct StubData {
            
            let accessToken: AccessTokenCredentials
            
        }
        
        let stubData = StubData(
            accessToken: AccessTokenCredentials(
                grantType: .jwt,
                token: "abcd1234"
            )
        )
        
        performTest {
            
            let middleware = AuthHTTPMiddleware(
                authDelegate: StubAuthManager(
                    auth: Auth(
                        credentials: stubData.accessToken,
                        provider: StubPasswordAuthProvider(
                            result: .success(stubData.accessToken)
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
                        "Bearer \(stubData.accessToken.token)"
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
