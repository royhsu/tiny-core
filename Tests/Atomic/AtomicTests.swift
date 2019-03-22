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

    func testDefault() {

        let atomic = Atomic(0)

        XCTAssertEqual(atomic.value, 0)

        XCTAssertEqual(atomic.createdDate, atomic.modifiedDate)
        
    }
    
    func testModifiedDate() {
        
        let atomic = Atomic(0)
        
        atomic.value = 1
        
        XCTAssert(atomic.createdDate < atomic.modifiedDate)
        
    }

    func testThreadSafety() {

        let iterations = 500

        let readsAndWrites = expectation(description: "Read and write the atomic value simultaneously.")

        readsAndWrites.expectedFulfillmentCount = iterations

        let atomic = Atomic(0)

        DispatchQueue.concurrentPerform(iterations: iterations) { count in

            defer { readsAndWrites.fulfill() }

            atomic.modify { value in

                value = count

                XCTAssertEqual(
                    value,
                    count
                )

            }

        }

        waitForExpectations(timeout: 10.0)

    }

    func testEquatable() {

        XCTAssertEqual(
            Atomic(0),
            Atomic(0)
        )

        XCTAssertNotEqual(
            Atomic(0),
            Atomic(1)
        )

    }

    func testDecodable() throws {

        let decoder = JSONDecoder()

        let data = try JSONSerialization.data(withJSONObject: [ 1 ])

        XCTAssertEqual(
            try decoder.decode([Atomic<Int>].self, from: data),
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
