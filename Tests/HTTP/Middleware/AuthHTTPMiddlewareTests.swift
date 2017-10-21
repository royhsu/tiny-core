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
                authDelegate: StubAuthManager(auth: nil)
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

    internal final func testAuthentication() {

        let promise = expectation(description: "Handle authentication.")

        struct StubData {

            let credentials: PasswordCredentials

        }

        let stubData = StubData(
            credentials: PasswordCredentials(
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
                    auth: Auth(
                        credentials: stubData.credentials,
                        provider: StubPasswordAuthProvider(
                            result: .success(stubData.credentials)
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
                        "Basic \(authorizationValue)"
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

    internal final func testAuthorization() {

        let promise = expectation(description: "Handle authorization.")

        struct StubData {

            let credentials: AccessTokenCredentials

        }

        let stubData = StubData(
            credentials: AccessTokenCredentials(
                grantType: .jwt,
                token: "abcd1234"
            )
        )

        performTest {

            let middleware = AuthHTTPMiddleware(
                authDelegate: StubAuthManager(
                    auth: Auth(
                        credentials: stubData.credentials,
                        provider: StubAccessTokenAuthProvider(
                            result: .success(stubData.credentials)
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
