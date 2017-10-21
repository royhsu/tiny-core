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

        }
        // swiftlint:enable nesting

        let data = Data(message: "Hello World")

        guard
            let messageData = data.message.data(using: .utf8)
        else {

            XCTFail("Data is required.")

            return

        }

        let client = StubHTTPClient(
            data: messageData
        )

        let middleware = StubHTTPClientMiddleware { request in

            var request = request

            request.setValue(
                "abcd1234",
                forHTTPHeaderField: "Authorization"
            )

            return request

        }

        let service = StubHTTPService(
            middlewares: [ middleware ],
            client: client
        )

        guard
            let url = URL(string: "http://api.foo.com")
        else {

            XCTFail("URL is invalid.")

            return

        }

        let endpoint = URLRequest(url: url)

        service.request(endpoint) { response in

            promise.fulfill()

            let authorizationHeader = response.request.value(forHTTPHeaderField: "Authorization")

            XCTAssertEqual(
                authorizationHeader,
                "abcd1234"
            )

            switch response.result {

            case .success(let value):

                let message = String(
                    data: value,
                    encoding: .utf8
                )

                XCTAssertEqual(
                    message,
                    data.message
                )

            case .failure(let error):

                XCTFail("\(error)")

            }

        }

        wait(
            for: [ promise ],
            timeout: 10.0
        )

    }

}
