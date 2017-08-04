//
//  IDTests.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 04/08/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - IDTests

import XCTest

class IDTests: XCTestCase {

    // MARK: Property

    static let allTests = [
        ("testEqual", testEqual),
        ("testHash", testHash),
        ("testDescription", testDescription)
    ]

    // MARK: Equal

    func testEqual() {

        XCTAssertEqual(
            UserID(rawValue: "1"),
            UserID(rawValue: "1")
        )

    }

    // MARK: Hash

    func testHash() {

        let value = "1"

        XCTAssertEqual(
            UserID(rawValue: value).hashValue,
            value.hashValue
        )

    }

    // MARK: Description

    func testDescription() {

        let value = "1"

        XCTAssertEqual(
            UserID(rawValue: value).description,
            value.description
        )

    }

}
