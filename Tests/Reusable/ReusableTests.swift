//
//  ReusableTests.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/2/23.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - ReusableTests

import XCTest

@testable import TinyCore

final class ReusableTests: XCTestCase {

    func testDefault() {

        XCTAssertEqual(
            Cell.reuseIdentifier,
            "Cell"
        )

    }

}

// MARK: - Cell

private struct Cell: Reusable { }
