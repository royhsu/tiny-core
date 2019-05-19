//
//  FutureTests.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 2019/5/19.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - FutureTests

import XCTest

@testable import TinyCore

final class FutureTests: XCTestCase {
    
    func testMap() {
        
        let didGetNumber = expectation(description: "Got a number.")
        
        let numberStringFuture: Future<String, Error> = Promise { completion in
            
            DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
                
                completion(.success("10"))
                
            }
            
        }
        
        numberStringFuture
            .map(Int.init)
            .await { result in
                
                defer { didGetNumber.fulfill() }
                
                XCTAssertEqual(try? result.get(), 10)
                
            }
        
        waitForExpectations(timeout: 10.0)
        
    }
    
}
