//
//  PropertyTests.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 2019/1/18.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - PropertyTests

import XCTest

@testable import TinyCore

internal final class PropertyTests: XCTestCase {
    
    internal final var observation: Observation?
    
    internal final func testObserveInitialValue() {
        
        let promise = expectation(description: "Get notified about value changes.")
        
        let property = Property<String>()
        
        observation = property.observe { change in

            promise.fulfill()
            
            switch change {

            case let .initial(newValue):

                XCTAssertEqual(
                    newValue,
                    "hello"
                )

            case .changed: XCTFail("Must be the initial value change.")

            }

        }
        
        property.setValue { $0 = "hello" }
        
        XCTAssertEqual(
            property.value,
            "hello"
        )
        
        wait(
            for: [ promise ],
            timeout: 10.0
        )
        
    }
    
    internal final func testObserveNewValue() {
        
        let promise = expectation(description: "Get notified about value changes.")
        
        let property = Property<String>()
        
        observation = property.observe { change in
            
            switch change {
                
            case .initial: break
                
            case let .changed(
                oldValue,
                newValue
            ):
                
                promise.fulfill()
                
                XCTAssertEqual(
                    oldValue,
                    "old value"
                )
                
                XCTAssertEqual(
                    newValue,
                    "new value"
                )
                
            }
            
        }
        
        property.setValue { $0 = "old value" }
        
        property.setValue { $0 = "new value" }
        
        wait(
            for: [ promise ],
            timeout: 10.0
        )
        
    }
    
    #warning("TODO: strange behavior.")
//    internal final func testBindKeyPath() {
//
//        let promise = expectation(description: "Bind the property to a destination.")
//
//        let view = TextView(text: "")
//
//        let property = Property<String>()
//
//        observation = property.observe { _ in
//
//            promise.fulfill()
//
//            XCTAssertEqual(
//                view.text,
//                "1"
//            )
//
//        }
//
//        property.bind(
//            on: .main,
//            transform: { $0 ?? "0" },
//            to: (view, \.text)
//        )
//
//        property.setValue { $0 = "1" }
//
//        XCTAssertEqual(
//            view.text,
//            "1"
//        )
//
//        wait(
//            for: [ promise ],
//            timeout: 10.0
//        )
//
//    }
    
//    internal final func testBindOptionalValueForKeyPath() {
//
//        let promise = expectation(description: "Bind the property to a destination.")
//
//        let view = OptionalTextView(text: "0")
//
//        let property = Property<String>()
//
//        property.bind(
//            to: (view, \.text)
//        )
//
//        XCTAssertEqual(
//            view.text,
//            nil
//        )
//
//        observation = property.observe(on: .main) { _ in
//
//            promise.fulfill()
//
//            XCTAssertEqual(
//                view.text,
//                "1"
//            )
//
//        }
//
//        property.setValue { $0 = "1" }
//
//        wait(
//            for: [ promise ],
//            timeout: 10.0
//        )
//
//    }
    
    internal final func testEquatable() {
        
        let property1 = Property<String>()
        
        property1.setValue { $0 = "hello" }
        
        let property2 = Property<String>()
        
        property2.setValue { $0 = "hello" }
        
        XCTAssertEqual(
            property1,
            property2
        )
        
    }
    
}

// MARK: - TextView

fileprivate final class TextView {
    
    internal final var text: String
    
    internal init(text: String) { self.text = text }
    
}

// MARK: - OptionalTextView

fileprivate final class OptionalTextView {
    
    internal final var text: String?
    
    internal init(text: String?) { self.text = text }
    
}
