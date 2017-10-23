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

    internal final func testUnauthorized() {

        let promise = expectation(description: "Catch unauthorized error.")

        performTest {

            let middleware = AuthHTTPMiddleware(
                authDelegate: StubAuthManager(
                    providerType: StubBasicAuthProvider.self
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

                    switch response.result {

                    case .success:

                        XCTFail("No error thrown.")

                    case .failure(let error):

                        XCTAssertEqual(
                            (error as? HTTPError),
                            .unauthorized
                        )

                        let response = response.response as? HTTPURLResponse

                        XCTAssertEqual(
                            response?.statusCode,
                            401
                        )

                    }

                }
            )

            result.completion(
                HTTPResponse(
                    request: result.request,
                    response: URLResponse(),
                    result: .success(Data())
                )
            )

            wait(
                for: [ promise ],
                timeout: 10.0
            )

        }

    }

    internal final func testBasicAuth() {

        let promise = expectation(description: "Handle basic auth.")

        struct StubData {

            let credentials: BasicAuthCredentials

        }

        let stubData = StubData(
            credentials: BasicAuthCredentials(
                username: "bar@foo.com",
                password: "password"
            )
        )

        performTest {

            let data = try unwrap(
                "\(stubData.credentials.username):\(stubData.credentials.password)".data(using: .utf8)
            )

            let authorizationValue = data.base64EncodedString()

            let middleware = AuthHTTPMiddleware(
                authDelegate: StubAuthManager(
                    stubAuth: Auth(credentials: stubData.credentials),
                    providerType: StubBasicAuthProvider.self
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
                        "Basic \(authorizationValue)"
                    )

                }
            )

            let noData = Data()

            result.completion(
                HTTPResponse(
                    request: result.request,
                    response: URLResponse(),
                    result: .success(noData)
                )
            )

        }

        wait(
            for: [ promise ],
            timeout: 10.0
        )

    }

    internal final func testAccessTokenAuth() {

        let promise = expectation(description: "Handle access token auth.")

        struct StubData {

            let credentials: AccessTokenCredentials

        }

        let stubData = StubData(
            credentials: AccessTokenCredentials(
                token: "abcd1234",
                tokenType: .bearer
            )
        )

        performTest {

            let middleware = AuthHTTPMiddleware(
                authDelegate: StubAuthManager(
                    stubAuth: Auth(credentials: stubData.credentials),
                    providerType: StubBasicAuthProvider.self
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
                        "Bearer \(stubData.credentials.token)"
                    )

                }
            )

            result.completion(
                HTTPResponse(
                    request: result.request,
                    response: URLResponse(),
                    result: .success(Data())
                )
            )

        }

        wait(
            for: [ promise ],
            timeout: 10.0
        )

    }

}
