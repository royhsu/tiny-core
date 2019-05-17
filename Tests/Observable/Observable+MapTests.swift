//
//  Observable_MapTests.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 2019/5/17.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - Observable_MapTests

import XCTest

@testable import TinyCore

final class Observable_MapTests: XCTestCase {
    
    func testMap() {
        
        let observeNumberFromNumericString = expectation(description: "Observe a mapped number from the numeric string.")
        
        let observeNilFromNonnumericString = expectation(description: "Observe the nil from the non-numeric string.")
        
        enum Step {
            
            case numericString
            
            case nonnumericString
            
        }
        
        var step: Step = .numericString
        
        let source = Property<String>()
        
        let destination = source.map { string -> Int? in
            
            guard let string = string else { return nil }
            
            return Int(string)
            
        }
        
        let observation = destination.observe { change in
            
            switch step {
            
            case .numericString:
                
                defer { observeNumberFromNumericString.fulfill() }
                
                XCTAssertEqual(change.currentValue, 1)
                
                step = .nonnumericString
                
                source.modify { $0 = "NaN" }
                
            case .nonnumericString:
                
                defer { observeNilFromNonnumericString.fulfill() }
                
                XCTAssertNil(change.currentValue)
                
            }
            
        }
        
        source.modify { $0 = "1" }
        
        waitForExpectations(timeout: 10.0)
        
    }
    
}
