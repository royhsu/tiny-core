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

internal final class AtomicTests: XCTestCase {

    #warning("TODO: not sure whether the testing do represent the real simultanenouly accessing. The testing will crash without the .barrier flag.")
    internal final func testThreadSafety() {

        let taskCount = 100

        let promise = expectation(description: "Read and write the atomic value simultaneously.")

        promise.expectedFulfillmentCount = taskCount

        let queue = DispatchQueue(
            label: "AtomicTests.ConcurrentQueue",
            attributes: .concurrent
        )

        let atomic = Atomic(value: 0)

        let tasks = (1...taskCount).map { count in

            return Task {

                queue.async(flags: .barrier) {

                    promise.fulfill()

                    atomic.mutateValue { $0 = count }

                    XCTAssertEqual(
                        atomic.value,
                        count
                    )

                }

            }

        }

        tasks.forEach { $0.execute() }

        wait(
            for: [ promise ],
            timeout: 10.0
        )

    }

    internal final func testEquatable() {

        XCTAssertEqual(
            Atomic(value: "1"),
            Atomic(value: "1")
        )

    }

}

// MARK: - Task

private struct Task {

    private let block: () -> Void

    internal init(block: @escaping () -> Void) { self.block = block }

    internal func execute() { block() }

}
