//
//  Property+CodableTests.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/3/22.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - Property_CodableTests

import XCTest

@testable import TinyCore

final class Property_CodableTests: XCTestCase {
    
    func testDecodable() throws {
        
        let data = try JSONSerialization.data(withJSONObject: [ 1 ])
        
        XCTAssertEqual(
            try JSONDecoder().decode([Property<Int>].self, from: data),
            [ Property(1) ]
        )
        
    }
    
    func testEncodable() throws {
        
        XCTAssertEqual(
            try JSONEncoder().encode([ Property(1) ]),
            try JSONSerialization.data(withJSONObject: [ 1 ])
        )
        
    }
    
}
