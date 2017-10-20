//
//  APIServiceTests.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 19/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - APIServiceTests

import XCTest

@testable import TinyCore

internal final class APIServiceTests: XCTestCase {

    // MARK: User

    internal final func testReadUserById() {

        let promise = expectation(description: "Read user by the given id.")

        // swiftlint:disable nesting
        struct Data {

            let user: User
            
            let accessToken: AccessToken

        }
        // swiftlint:enable nesting

        let data = Data(
            user: User(
                id: UserID("1"),
                name: "Roy"
            ),
            accessToken: AccessToken(rawValue: "abcd1234")
        )

        do {

            let credential = Credential.accessToken(data.accessToken)
            
            let json = try JSONEncoder().encode(data.user)

            let service: UserAPIService = APIService(
                auth: StubAuth(credential: credential),
                client: StubHTTPClient(data: json)
            )
            
            service.readUser(id: data.user.id) { result in
                
                promise.fulfill()
                
                switch result {
                    
                case .success(let user):
                    
                    XCTAssertEqual(
                        user,
                        data.user
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
        catch { XCTFail("\(error)") }

    }

}
