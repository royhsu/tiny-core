//
//  UserManagerTests.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 23/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - UserManagerTests

import XCTest

@testable import TinyCore

internal final class UserManagerTests: XCTestCase, AuthDelegate {
    
    // MARK: Property
    
    internal final var grantedAuth: Auth?
    
    internal final var providerType: AuthProvider.Type {
        
        return AccessTokenProvider.self as! AuthProvider.Type
        
    }
    
    // MARK: Set Up
    
    internal final override func setUp() {
        super.setUp()
        
        grantedAuth = Auth(
            credentials: AccessTokenCredentials(
                token: "abcd1234",
                tokenType: .bearer
            )
        )
        
    }
    
    internal final override func tearDown() {
        
        grantedAuth = nil
        
        super.tearDown()
    }
    
    // MARK: Read User By Id
    
    internal final func testReadUserById() {
        
        let promise = expectation(description: "Read user by id.")
        
        performTest {
            
            struct StubData {
                
                let user: User
                
            }
            
            let stubData = StubData(
                user: User(
                    id: UserID("1"),
                    name: "John Appleseed"
                )
            )
            
            let userData = try JSONEncoder().encode(stubData.user)
            
            let service = StubHTTPService(
                client: StubHTTPClient(
                    stubData: userData
                )
            )
            
            let manager = UserManager(
                authDelegate: self,
                service: service
            )
            
            manager.readUser(
                id: stubData.user.id,
                completion: { result in
                    
                    promise.fulfill()
                    
                    switch result {
                        
                    case .success(let user):
                        
                        XCTAssertEqual(
                            user,
                            stubData.user
                        )
                        
                    case .failure(let error):
                        
                        XCTFail("\(error)")
                        
                    }
                    
                }
            )
            
        }
        
        wait(
            for: [ promise ],
            timeout: 10.0
        )
        
    }
    
}
