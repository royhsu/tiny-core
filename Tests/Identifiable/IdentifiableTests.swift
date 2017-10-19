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

internal final class IdentifiableTests: XCTestCase {

    // MARK: Property

    internal static let allTests = [
        ("testIdentifier", testIdentifier)
    ]

    // MARK: Identifier

    internal final func testIdentifier() {

        XCTAssertEqual(
            User.identifier,
            "User"
        )

    }

}
