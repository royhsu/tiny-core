//
//  IDTests.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 04/08/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - IDTests

import XCTest

internal final class IDTests: XCTestCase {

    // MARK: Property

    internal static let allTests = [
        ("testEqual", testEqual),
        ("testHash", testHash),
        ("testDescription", testDescription)
    ]

    // MARK: Equal

    internal final func testEqual() {

        XCTAssertEqual(
            UserID("1"),
            UserID("1")
        )

    }

    // MARK: Hash

    internal final func testHash() {

        let value = "1"

        XCTAssertEqual(
            UserID(value).hashValue,
            value.hashValue
        )

    }

    // MARK: Description

    internal final func testDescription() {

        let value = "1"

        XCTAssertEqual(
            UserID(value).description,
            value.description
        )

    }

}
