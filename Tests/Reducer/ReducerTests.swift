//
//  ReducerTests.swift
//  TinyCore
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

        let reducer = Reducer<String, Counter>(
            initialValue: Counter(initialNumber: 3)
        )
        
        let counterActions: [CounterAction] = [
            .increment(
                identifier: "first",
                willBegin: { counter in
                    
                    XCTAssert(reducer.isReducing)
                    
                    XCTAssertEqual(
                        reducer.pendingActions.map { $0.identifier },
                        [
                            "first",
                            "second"
                        ]
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
                        4
                    )
                    
                }
            ),
            .decrement(
                identifier: "second",
                willBegin: { counter in
                    
                    XCTAssert(reducer.isReducing)
                    
                    XCTAssertEqual(
                        reducer.pendingActions.map { $0.identifier },
                        [ "second" ]
                    )
                    
                    XCTAssertEqual(
                        counter.currentNumber,
                        4
                    )
                    
                },
                didEnd: { counter in
                    
                    defer { numberDecremented.fulfill() }
                    
                    XCTAssert(reducer.isReducing)
                    
                    XCTAssert(reducer.pendingActions.isEmpty)
                    
                    XCTAssertEqual(
                        counter.currentNumber,
                        3
                    )
                    
                }
            ),
        ]
        
        reducer.actions = counterActions.map { $0.action }
        
        reducer.reduce { reducer in
            
            defer { allActionsRedueced.fulfill() }
            
            XCTAssertFalse(reducer.isReducing)
            
            XCTAssertEqual(
                reducer.currentValue.currentNumber,
                3
            )
            
        }
        
        waitForExpectations(timeout: 10.0)

    }
    
}

//        let actions: [CounterAction] = [
//            .increment,
//            .increment,
//            .decrement
//        ]
//
//        let initialCounter = Counter(count: 3)
//
//        actions.reduce(initialCounter) { finalCounter in
//
//            XCTAssertEqual(
//                finalCounter.count,
//                3 + 1 + 1 - 1
//            )
//
//        }

// MARK: - CounterAction

extension ReducerTests {

    enum CounterAction {
        
        case increment(
            identifier: String,
            willBegin: (Counter) -> Void,
            didEnd: (Counter) -> Void
        )

        case decrement(
            identifier: String,
            willBegin: (Counter) -> Void,
            didEnd: (Counter) -> Void
        )
        
        var identifier: String {
            
            switch self {
                
            case let .increment(identifier, _, _): return identifier
             
            case let .decrement(identifier, _, _): return identifier
                
            }
            
        }
        
        var action: ReducibleAction<String, Counter> {

            switch self {
    
            case let .increment(identifier, willBegin, didEnd):
    
                return ReducibleAction(identifier: identifier) { currentCounter, completion in
    
                    willBegin(currentCounter)
    
                    var nextCounter = currentCounter
    
                    nextCounter.increment()
    
                    didEnd(nextCounter)
    
                    completion(nextCounter)
    
                }
    
            case let .decrement(identifier, willBegin, didEnd):
    
                return ReducibleAction(identifier: identifier) { currentCounter, completion in
    
                    willBegin(currentCounter)
    
                    var nextCounter = currentCounter
    
                    nextCounter.decrement()
    
                    didEnd(nextCounter)
    
                    completion(nextCounter)
    
                }
    
            }
    
        }

    }
    
}

// MARK: - Counter

extension ReducerTests {

    struct Counter {
        
        private(set) var currentNumber: Int
        
        init(initialNumber: Int = 0) { self.currentNumber = initialNumber }
        
    }

}

extension ReducerTests.Counter {
    
    mutating func increment() { currentNumber += 1 }
    
    mutating func decrement() { currentNumber -= 1 }
    
}

// MARK: - Equatable

extension ReducerTests.Counter: Equatable {
    
    static func ==(
        lhs: ReducerTests.Counter,
        rhs: ReducerTests.Counter
    )
    -> Bool { return lhs.currentNumber == rhs.currentNumber }
    
}
