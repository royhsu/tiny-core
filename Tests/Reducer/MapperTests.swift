//
//  MapperTests.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 2019/5/18.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - MapperTests

import XCTest

@testable import TinyCore

final class MapperTests: XCTestCase {
    
    func testMap() {
        
        let mapNumber = expectation(description: "Map a number to a string.")
        
        let mapper = Mapper<Int, String> { fromNumber, completion in
            
            completion("\(fromNumber)")
            
        }
        
        mapper.map(10) { result in
            
            mapNumber.fulfill()
            
            XCTAssertEqual(result, "10")
            
        }
        
        waitForExpectations(timeout: 10.0)
        
    }
    
}
