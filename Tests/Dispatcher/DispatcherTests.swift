//
//  DispatcherTests.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 2019/2/22.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

import XCTest

@testable import TinyCore

final class DispatcherTests: XCTestCase {

    private let expectionTimeout = 5.0

    func testBatchTask() {

        let batchTask = expectation(description: "Execute the batch task.")

        let counter = Counter(limitNumber: 2)

        let dispatcher = Dispatcher<String>(
            batchScheduler: counter,
            batchTask: { dispatcher, batchItems in

                defer { batchTask.fulfill() }

                XCTAssertEqual(
                    batchItems,
                    [
                        "c",
                        "a"
                    ]
                )

                XCTAssertEqual(
                    dispatcher.queue,
                    [ "e" ]
                )

            }
        )

        dispatcher.dispatch("c")

        counter.count()

        dispatcher.dispatch("a")

        // This will make the counter reach the number.
        counter.count()

        dispatcher.dispatch("e")

        counter.count()

        waitForExpectations(timeout: expectionTimeout)

    }

}
