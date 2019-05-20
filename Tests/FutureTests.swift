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
            
            DispatchQueue.global().async { completion(.success("10")) }
            
        }
        
        numberStringFuture
            .map(Int.init)
            .await { result in
                
                defer { didGetNumber.fulfill() }
                
                XCTAssertEqual(try? result.get(), 10)
                
            }
        
        waitForExpectations(timeout: 10.0)
        
    }
    
    func testFlatMap() {
        
        let didGetNumber = expectation(description: "Got a number.")
        
        let numberStringFuture: Future<String, Error> = Promise { completion in
            
            DispatchQueue.global().async { completion(.success("10")) }
            
        }
        
        numberStringFuture
            .flatMap(parseNumber)
            .await { result in
                
                defer { didGetNumber.fulfill() }
                
                XCTAssertEqual(try? result.get(), 10)
                
            }
        
        waitForExpectations(timeout: 10.0)
        
    }
    
    func testMapError() {
        
        let didGetError = expectation(description: "Got an error.")
        
        authorize()
            .mapError { _ in AuthError.missingAuth }
            .await { result in
            
                defer { didGetError.fulfill() }
                
                do {
                    
                    _ = try result.get()
                    
                    XCTFail()
                    
                }
                catch AuthError.missingAuth { XCTSuccess() }
                catch { XCTFail("Undefined error.") }
                
            }
        
        waitForExpectations(timeout: 10.0)
        
    }
    
    func testFlatMapError() {
        
        let didGetError = expectation(description: "Got an error.")
        
        authorize()
            .flatMapError { _ in
                
                Promise { completion in
                    
                    completion(.failure(AuthError.missingAuth))
                    
                }
                
            }
            .await { result in
                
                defer { didGetError.fulfill() }
                
                do {
                    
                    _ = try result.get()
                    
                    XCTFail()
                    
                }
                catch AuthError.missingAuth { XCTSuccess() }
                catch { XCTFail("Undefined error.") }
                
            }
        
        waitForExpectations(timeout: 10.0)
        
    }
    
    private func parseNumber(from string: String) -> Promise<Int, Error> {
        
        return Promise<Int, Error> { completion in
            
            guard let number = Int(string) else {
                
                completion(.failure(NumberError.notNumberString))
                
                return
                
            }
            
            completion(.success(number))
            
        }
        
    }
    
    private enum NumberError: Error {
    
        case notNumberString
    
    }
    
    private func authorize() -> Promise<Void, HTTPError> {
        
        return Promise { completion in
            
            DispatchQueue.global().async { completion(.failure(.unauthorized)) }
            
        }
        
    }
 
    private enum HTTPError: Error {
        
        case unauthorized
        
    }
    
    private enum AuthError: Error {
        
        case missingAuth
        
    }
    
}
