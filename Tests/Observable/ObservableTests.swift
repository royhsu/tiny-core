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

    internal final var subscription: ObservableSubscription?
    
    internal final func testInitializeObservable() {
        
        let observable = Observable<String>()
        
        XCTAssertNil(observable.value)
        
    }
    
    internal final func testSetValueByAccessingProperty() {
        
        let promise = expectation(description: "Get notified about the changes.")
        
        let observable = Observable<String>()
        
        subscription = observable.subscribe { event in
            
            promise.fulfill()
            
            XCTAssertEqual(
                event.currentValue,
                "Hello"
            )
            
        }
        
        observable.value = "Hello"
        
        wait(
            for: [ promise ],
            timeout: 10.0
        )
        
    }
    
    internal final func testSetValueThroughSetter() {
        
        let promise = expectation(description: "Get notified about the changes.")
        
        let observable = Observable<String>()
        
        subscription = observable.subscribe { event in
            
            promise.fulfill()
            
            XCTAssertEqual(
                event.currentValue,
                "Hello"
            )
            
        }
        
        observable.setValue("Hello")
        
        wait(
            for: [ promise ],
            timeout: 10.0
        )
        
    }
    
    internal final func testSetValueThroughtSetterWithMuteBroadcasterOptions() {
        
        let observable = Observable<String>()
        
        subscription = observable.subscribe { _ in
            
            XCTFail("Shouldn't get notified.")
            
        }
        
        observable.setValue(
            "Hello",
            options: .muteBroadcaster
        )
        
    }

}
