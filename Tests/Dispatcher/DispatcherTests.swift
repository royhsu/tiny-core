//
//  DispatcherTests.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 2019/2/22.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - DispatcherTests

import XCTest

@testable import TinyCore

final class DispatcherTests: XCTestCase {

    func testBatchTask() {

        let batchTask = expectation(description: "Execute the batch task.")

        var numberCounter = NumberCounter(targetCount: 100)
        
        let dispatcher = Dispatcher(
            batchScheduler: numberCounter,
            batchTask: { batchNumbers in

                defer { batchTask.fulfill() }

                XCTAssertEqual(batchNumbers.count, 100)

            }
        )

        DispatchQueue.concurrentPerform(iterations: 150) { count in
            
            let number = count + 1
            
            dispatcher.dispatch(number) { _ in numberCounter.increment() }
            
        }

        waitForExpectations(timeout: 10.0)

    }

}
