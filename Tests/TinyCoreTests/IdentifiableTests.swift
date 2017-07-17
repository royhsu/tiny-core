//
//  IdentifiableTests.swift
//  TinyCore
//
//  Created by Roy Hsu on 17/07/2017.
//
//

// MARK: - IdentifiableTests

import XCTest

@testable import TinyCore

class IdentifiableTests: XCTestCase {

    // MARK: Property

    static let allTests = [
        ("testIdentifier", testIdentifier)
    ]

    // MARK: Identifier

    func testIdentifier() {

        XCTAssertEqual(
            IdentifiableTestObject.identifier,
            "IdentifiableTestObject"
        )

    }

}
