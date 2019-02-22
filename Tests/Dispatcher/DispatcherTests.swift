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
        
        let counter = Counter(number: 2)
        
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

// MARK: - Counter

fileprivate class Counter {
    
    private let number: Int
    
    private var value = 0
    
    private var completion: ( (Counter) -> Void )?
    
    init(number: Int) { self.number = number }
    
}

extension Counter {
    
    func count() {
        
        if value > number { preconditionFailure("The counter has reached the number.") }
        
        value += 1
        
        guard value == number else { return }
            
        completion?(self)
        
    }
    
}

// MARK: - DispatcherBatchScheduler

extension Counter: DispatcherBatchScheduler {
    
    func scheduleTask(
        _ task: @escaping (DispatcherBatchScheduler) -> Void
    ) { completion = task }
    
}
