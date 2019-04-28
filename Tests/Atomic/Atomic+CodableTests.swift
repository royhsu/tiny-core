//
//  Atomic+CodableTests.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 2019/3/22.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - Atomic_CodaleTests

import XCTest

@testable import TinyCore

final class Atomic_CodaleTests: XCTestCase {

    func testDecodable() throws {

        let data = try JSONSerialization.data(withJSONObject: [ 1 ])

        XCTAssertEqual(
            try JSONDecoder().decode([Atomic<Int>].self, from: data),
            [ Atomic(1) ]
        )

    }

    func testEncodable() throws {

        XCTAssertEqual(
            try JSONEncoder().encode([ Atomic(1) ]),
            try JSONSerialization.data(withJSONObject: [ 1 ])
        )

    }

}
