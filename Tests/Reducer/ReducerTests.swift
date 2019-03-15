//
//  ReducerTests.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 2019/3/14.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - ReducerTests

import XCTest

@testable import TinyCore

final class ReducerTests: XCTestCase {

    func testDefault() {

        let counter = Counter()

        let reducer = Reducer<String, Counter>(initialValue: counter)

        XCTAssertEqual(
            reducer.currentValue,
            counter
        )

        XCTAssert(reducer.actions.isEmpty)

        XCTAssertFalse(reducer.isReducing)

    }

    func testReduce() {

        let numberIncremented = expectation(description: "Increment the number.")

        let numberDecremented = expectation(description: "Decrement the number.")

        let allActionsRedueced = expectation(description: "All actions are reduced.")

        let counter = Counter(initialNumber: 3)

        let reducer = Reducer<String, Counter>(initialValue: counter)

        let counterActions: [CounterAction] = [
            .increment(
                identifier: "first",
                number: 2,
                willBegin: { counter in

                    XCTAssert(reducer.isReducing)

                    XCTAssertEqual(
                        reducer.pendingActions.map { $0.identifier },
                        [ "second" ]
                    )

                    XCTAssertEqual(
                        counter.currentNumber,
                        3
                    )

                },
                didEnd: { counter in

                    defer { numberIncremented.fulfill() }

                    XCTAssert(reducer.isReducing)

                    XCTAssertEqual(
                        reducer.pendingActions.map { $0.identifier },
                        [ "second" ]
                    )

                    XCTAssertEqual(
                        counter.currentNumber,
                        3 + 2
                    )

                }
            ),
            .decrement(
                identifier: "second",
                number: 1,
                willBegin: { counter in

                    XCTAssert(reducer.isReducing)

                    XCTAssert(reducer.pendingActions.isEmpty)

                    XCTAssertEqual(
                        counter.currentNumber,
                        5
                    )

                },
                didEnd: { counter in

                    defer { numberDecremented.fulfill() }

                    XCTAssert(reducer.isReducing)

                    XCTAssert(reducer.pendingActions.isEmpty)

                    XCTAssertEqual(
                        counter.currentNumber,
                        5 - 1
                    )

                }
            )
        ]

        reducer.actions = counterActions.map { $0.action }

        reducer.reduce { reducer in

            defer { allActionsRedueced.fulfill() }

            XCTAssertFalse(reducer.isReducing)

            XCTAssertEqual(
                reducer.currentValue.currentNumber,
                4
            )

        }

        waitForExpectations(timeout: 10.0)

    }

}
