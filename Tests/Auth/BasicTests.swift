//
//  BasicTests.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 2019/3/16.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - BasicTests

import XCTest

@testable import TinyCore

final class BasicTests: XCTestCase {

    func testDefault() {

        let basic = Basic(
            username: "username",
            password: "password"
        )

        XCTAssertEqual(
            basic.username,
            "username"
        )

        XCTAssertEqual(
            basic.password,
            "password"
        )

    }

    func testHTTPHeader() throws {

        let basic = Basic(
            username: "username",
            password: "password"
        )

        let httpHeader = try basic.httpHeader()

        XCTAssertEqual(
            httpHeader.field,
            .authorization
        )

        XCTAssertEqual(
            httpHeader.value,
            "Basic dXNlcm5hbWU6cGFzc3dvcmQ="
        )

    }

}
