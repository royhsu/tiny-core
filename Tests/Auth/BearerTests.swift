//
//  BearerTests.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 2019/3/16.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - BearerTests

import XCTest

@testable import TinyCore

final class BearerTests: XCTestCase {

    func testDefault() {

        let bearer = Bearer(token: "token")

        XCTAssertEqual(
            bearer.token,
            "token"
        )

    }

    func testHTTPHeader() throws {

        let bearer = Bearer(token: "token")

        let httpHeader = try bearer.httpHeader()

        XCTAssertEqual(
            httpHeader.field,
            .authorization
        )

        XCTAssertEqual(
            httpHeader.value,
            "Bearer token"
        )

    }

}
