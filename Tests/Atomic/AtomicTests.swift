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

    func testModify() {

        let atomic = Atomic(0)

        atomic.modify { $0 = 1 }

        XCTAssertEqual(atomic.value, 1)

        XCTAssert(atomic.createdDate < atomic.modifiedDate)

    }

    func testThreadSafety() {

        let iterations = 500

        let readsAndWrites = expectation(description: "Read and write the atomic value simultaneously.")

        readsAndWrites.expectedFulfillmentCount = iterations

        let atomic = Atomic(0)

        DispatchQueue.concurrentPerform(iterations: iterations) { count in

            defer { readsAndWrites.fulfill() }

            atomic.modify { number in

                number = count

                XCTAssertEqual(number, count)

            }
            
        }

        waitForExpectations(timeout: 10.0)

    }

    func testEquatable() {

        XCTAssertEqual(Atomic(0), Atomic(0))

        XCTAssertNotEqual(Atomic(0), Atomic(1))

    }

}
