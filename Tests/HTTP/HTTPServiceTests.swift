//
//  HTTPServiceTests.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 21/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - HTTPServiceTests

import XCTest

@testable import TinyCore

internal final class HTTPServiceTests: XCTestCase {

    // MARK: Middlewares

    internal final func testMiddlewares() {

        let promise = expectation(description: "Run middlewares.")

        // swiftlint:disable nesting
        struct Data {

            let message: String

            let credentials: AccessTokenCredentials

        }
        // swiftlint:enable nesting

        let stubData = Data(
            message: "Hello World",
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

            let messageData = try unwrap(
                stubData.message.data(using: .utf8)
            )

            let service = StubHTTPService(
                client: StubHTTPClient(stubData: messageData)
            )

            let url = try unwrap(
                URL(string: "http://api.foo.com")
            )

            let endpoint = URLRequest(url: url)

            service.request(
                endpoint,
                middlewares: [ middleware ],
                completion: { response in

                    performTest {

                        promise.fulfill()

                        switch response.result {

                        case .success(let value):

                            let authorizationHeader = response.request.value(forHTTPHeaderField: "Authorization")

                            XCTAssertEqual(
                                authorizationHeader,
                                try stubData.credentials.valueForAuthorizationHTTPHeader()
                            )

                            let message = String(
                                data: value,
                                encoding: .utf8
                            )

                            XCTAssertEqual(
                                message,
                                stubData.message
                            )

                        case .failure(let error):

                            XCTFail("\(error)")

                        }

                    }

                }
            )

        }

        wait(
            for: [ promise ],
            timeout: 10.0
        )

    }

}
