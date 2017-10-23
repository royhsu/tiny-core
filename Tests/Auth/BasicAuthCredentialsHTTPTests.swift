//
//  BasicAuthCredentialsHTTPTests.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 23/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - BasicAuthCredentialsHTTPTests

import XCTest

@testable import TinyCore

internal final class BasicAuthCredentialsHTTPTests: XCTestCase {

    // MARK: - Authorization HTTP Header

    internal final func testAuthorizationHTTPHeader() {

        performTest {

            struct StubData {

                let username: String

                let password: String

            }

            let stubData = StubData(
                username: "bar@foo.com",
                password: "password"
            )

            let credentials = BasicAuthCredentials(
                username: stubData.username,
                password: stubData.password
            )

            let headerData = try unwrap(
                "\(credentials.username):\(credentials.password)".data(using: .utf8)
            )

            let headerValue = headerData.base64EncodedString()

            XCTAssertEqual(
                try credentials.valueForAuthorizationHTTPHeader(),
                "Basic \(headerValue)"
            )

        }

    }

}
