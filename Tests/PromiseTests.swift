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
        
            DispatchQueue.global().async {
        
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
        
        let messagePromise = Promise(resolving: messageResolver)
        
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
        
        Promise(resolving: messageResolver).await { result in
            
            defer { didReceiveMessage.fulfill() }
            
            XCTAssertEqual(try? result.get(), "first")
            
            Promise(resolving: self.messageResolver).await { result in
                
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
        
        if elements.isEmpty { return nil }
        
        return elements.removeFirst()
        
    }
    
}
