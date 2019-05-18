//
//  SerialReducerQueueTests.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 2019/5/18.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - SerialReducerQueueTests

import XCTest

@testable import TinyCore

final class SerialReducerQueueTests: XCTestCase {
    
    func testReduce() {
        
        let allReducersFinished = expectation(description: "All reducers in the queue are finished.")
        
        let incrementNumberByOne = AnyReducer<Int> { number, completion in
            
            DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
                
                completion(number + 1)
                
            }
            
        }
        
        let squareNumber = AnyReducer<Int> { number, completion in
            
            DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
                
                completion(number * number)
                
            }
            
        }
        
        let queue: SerialReducerQueue<Int> = [
            incrementNumberByOne,
            squareNumber
        ]
        
        queue.reduce(9) { finalNumber in
            
            defer { allReducersFinished.fulfill() }
            
            // (9 + 1) ^ 2.
            XCTAssertEqual(finalNumber, 100)
            
        }
        
        waitForExpectations(timeout: 10.0)
        
    }
    
}
