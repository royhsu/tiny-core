//
//  CombinedReducersTests.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 2019/3/14.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - CombinedReducersTests

import XCTest

@testable import TinyCore

final class CombinedReducersTests: XCTestCase {

    func testDefault() {

        let counter = Counter()

        let reducers = CombinedReducers<String, Counter>(initialValue: counter)

        XCTAssertEqual(
            reducers.currentValue,
            counter
        )

        XCTAssert(reducers.actions.isEmpty)

        XCTAssertFalse(reducers.isReducing)

    }

    func testReduce() {

        let numberIncremented = expectation(description: "Increment the number.")

        let numberDecremented = expectation(description: "Decrement the number.")

        let allActionsRedueced = expectation(description: "All actions are reduced.")

        let counter = Counter(initialNumber: 3)

        let reducers = CombinedReducers<String, Counter>(initialValue: counter)

        let counterActions: [CounterAction] = [
            .increment(
                identifier: "first",
                number: 2,
                willBegin: { counter in

                    XCTAssert(reducers.isReducing)

                    XCTAssertEqual(
                        reducers.pendingActions.map { $0.identifier },
                        [ "second" ]
                    )

                    XCTAssertEqual(
                        counter.currentNumber,
                        3
                    )

                },
                didEnd: { counter in

                    defer { numberIncremented.fulfill() }

                    XCTAssert(reducers.isReducing)

                    XCTAssertEqual(
                        reducers.pendingActions.map { $0.identifier },
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

                    XCTAssert(reducers.isReducing)

                    XCTAssert(reducers.pendingActions.isEmpty)

                    XCTAssertEqual(
                        counter.currentNumber,
                        5
                    )

                },
                didEnd: { counter in

                    defer { numberDecremented.fulfill() }

                    XCTAssert(reducers.isReducing)

                    XCTAssert(reducers.pendingActions.isEmpty)

                    XCTAssertEqual(
                        counter.currentNumber,
                        5 - 1
                    )

                }
            )
        ]

        reducers.actions = counterActions.map { $0.action }

        reducers.reduce { reducers in

            defer { allActionsRedueced.fulfill() }

            XCTAssertFalse(reducers.isReducing)

            XCTAssertEqual(
                reducers.currentValue.currentNumber,
                4
            )

        }

        waitForExpectations(timeout: 10.0)

    }

}
