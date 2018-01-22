//
//  UserTests.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 22/01/2018.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - UserTests

import XCTest

internal final class UserTests: XCTestCase {

    // MARK: Equatable

    internal final func testEquatable() {

        XCTAssertEqual(
            User(
                id: UserID(rawValue: "1")
            ),
            User(
                id: UserID(rawValue: "1")
            )
        )

    }

}
