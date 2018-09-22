//
//  ObservableTests.swift
//  TinyCore Tests
//
//  Created by Roy Hsu on 2018/9/11.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - ObservableTests

import XCTest

@testable import TinyCore

internal final class ObservableTests: XCTestCase {

    internal final var obveration: Observation?
    
    internal final func testInitialize() {
        
        let observable = Observable<String>()
        
        XCTAssert(observable.value == nil)
        
    }
    
    internal final func testSetValue() {
        
        let promise = expectation(description: "Get notified about the changes.")
        
        var observable = Observable<String>()
        
        obveration = observable.observe { change in
            
            promise.fulfill()
            
            XCTAssertEqual(
                change.currentValue,
                "hello"
            )
            
        }
        
        observable.setValue("hello")
        
        XCTAssertEqual(
            observable.value,
            "hello"
        )
        
        wait(
            for: [ promise ],
            timeout: 10.0
        )
        
    }

}
