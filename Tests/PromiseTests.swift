//
//  PromiseTests.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 2019/5/19.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - PromiseTests

import XCTest

@testable import TinyCore

final class PromiseTests: XCTestCase {
    
    var messages: Stack<String>?
    
    var messageResolver: Promise<String, Error>.Resolver {
        
        return { completion in
        
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 1.0) {
        
                guard let message = self.messages?.pop() else {

                    XCTFail("No more element in the message stack.")

                    return

                }

                completion(.success(message))

            }
            
        }

    }
    
    override func setUp() {
        
        super.setUp()
        
        messages = [ "first", "second" ]
        
    }
    
    override func tearDown() {
        
        messages = nil
        
        super.tearDown()
        
    }
    
    func testGetSameResultOncePromiseResolved() {
        
        let didReceiveMessage = expectation(description: "Received a message.")
        
        didReceiveMessage.expectedFulfillmentCount = 2
        
        let messagePromise = Promise(messageResolver)
        
        messagePromise.await { result in
            
            defer { didReceiveMessage.fulfill() }
            
            XCTAssertEqual(try? result.get(), "first")
            
            messagePromise.await { result in
                
                defer { didReceiveMessage.fulfill() }
                
                XCTAssertEqual(try? result.get(), "first")
                
            }
            
        }
        
        waitForExpectations(timeout: 10.0)
        
    }
    
    func testDifferentPromisesAreIndependent() {
        
        let didReceiveMessage = expectation(description: "Received a message.")
        
        didReceiveMessage.expectedFulfillmentCount = 2
        
        Promise(messageResolver).await { result in
            
            defer { didReceiveMessage.fulfill() }
            
            XCTAssertEqual(try? result.get(), "first")
            
            Promise(self.messageResolver).await { result in
                
                defer { didReceiveMessage.fulfill() }
                
                XCTAssertEqual(try? result.get(), "second")
                
            }
            
        }
        
        waitForExpectations(timeout: 10.0)
        
    }
    
}

// MARK: - Stack

struct Stack<Element>: ExpressibleByArrayLiteral {
    
    private(set) var elements: [Element]
    
    init(arrayLiteral elements: Element...) { self.elements = elements }
    
}

extension Stack {
    
    mutating func pop() -> Element? {
        
        print("Bofore popping elements", elements)
        
        if elements.isEmpty { return nil }
        
        let element = elements.removeFirst()
        
        print("After popping elements", elements, "popped", element)
        
        return element
        
    }
    
}
