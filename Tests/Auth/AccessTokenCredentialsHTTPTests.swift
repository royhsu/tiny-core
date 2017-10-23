//
//  AccessTokenCredentialsHTTPTests.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 23/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - AccessTokenCredentialsHTTPTests

import XCTest

@testable import TinyCore

internal final class AccessTokenCredentialsHTTPTests: XCTestCase {

    // MARK: - Authorization HTTP Header

    internal final func testAuthorizationHTTPHeader() {

        performTest {

            struct StubData {

                let token: String

                let tokenType: AccessTokenType

            }

            let stubData = StubData(
                token: "abcd1234",
                tokenType: .bearer
            )

            let credentials = AccessTokenCredentials(
                token: stubData.token,
                tokenType: stubData.tokenType
            )

            XCTAssertEqual(
                try credentials.valueForAuthorizationHTTPHeader(),
                "\(stubData.tokenType.rawValue.capitalized) \(stubData.token)"
            )

        }

    }

}
