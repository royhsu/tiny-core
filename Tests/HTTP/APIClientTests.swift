//
//  APIClientTests.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 19/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - APIClientTests

import XCTest

@testable import TinyCore

internal final class APIClientTests: XCTestCase {
    
    // MARK: User
    
    internal final func testReadUserById() {
        
        let promise = expectation(description: "Read user by the given id.")
        
        struct Data {
            
            static let userId = "1"
            
            static let userObject: [String: Any] = [
                "id": userId
            ]
            
        }
        
        let client: UserAPIClient = APIClient(
            httpClient: StubHTTPClient(value: Data.userObject)
        )
        
        client.readUser(id: Data.userId) { result in
            
            promise.fulfill()

            switch result {

            case .success(let user):

                XCTAssertEqual(
                    user,
                    User(id: Data.userId)
                )

            case .failure(let error):

                XCTFail("\(error)")

            }

        }

        wait(
            for: [ promise ],
            timeout: 10.0
        )
        
    }
    
}
