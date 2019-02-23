//
//  AtomicTests.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 2019/1/18.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - AtomicTests

import XCTest

@testable import TinyCore

final class AtomicTests: XCTestCase {

    private let expectionTimeout = 5.0

    func testDefault() {

        let atomic = Atomic(value: "default")

        XCTAssertEqual(
            atomic.value,
            "default"
        )

    }

    func testThreadSafety() {

        let iterations = 500

        let readsAndWrites = expectation(description: "Read and write the atomic value simultaneously.")

        readsAndWrites.expectedFulfillmentCount = iterations

        let atomic = Atomic(value: 0)

        DispatchQueue.concurrentPerform(iterations: iterations) { count in

            defer { readsAndWrites.fulfill() }

            atomic.mutateValue { value in

                value = count

                XCTAssertEqual(
                    value,
                    count
                )

            }

        }

        waitForExpectations(timeout: expectionTimeout)

    }

    func testEquatable() {

        XCTAssertEqual(
            Atomic(value: 1),
            Atomic(value: 1)
        )

        XCTAssertNotEqual(
            Atomic(value: 0),
            Atomic(value: 1)
        )

    }

    func testDecodable() throws {

        let decoder = JSONDecoder()

        let data = try JSONSerialization.data(withJSONObject: [ 1, 2 ])

        let decodedProperties = try decoder.decode(
            [Atomic<Int>].self,
            from: data
        )

        XCTAssertEqual(
            decodedProperties,
            [
                Atomic(value: 1),
                Atomic(value: 2)
            ]
        )

    }

    func testEncodable() throws {

        let encoder = JSONEncoder()

        XCTAssertEqual(
            try encoder.encode(
                [
                    Atomic(value: 1),
                    Atomic(value: 2)
                ]
            ),
            try JSONSerialization.data(withJSONObject: [ 1, 2 ])
        )

    }

}
