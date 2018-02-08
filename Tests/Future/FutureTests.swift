//
//  FutureTests.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 08/02/2018.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - FutureTests

import XCTest

@testable import TinyCore

internal final class FutureTests: XCTestCase {
    
    internal final func testThen() {
        
        let promise = expectation(description: "Then should be executed.")
        
        let future = Future(
            Promise<Int>(in: .main) { fulfill, reject, _ in
            
                fulfill(10)
            
            }
        )
        
        future
            .then(in: .main) { result -> Void in
            
                XCTAssertEqual(
                    result,
                    10
                )
                
                promise.fulfill()
                
            }
            .catch(in: .main) { error in
            
                XCTFail("\(error)")
                
                promise.fulfill()
                
            }
        
        wait(
            for: [ promise ],
            timeout: 10.0
        )
        
    }
    
    internal final func testAlways() {
        
        
        
    }
    
}
