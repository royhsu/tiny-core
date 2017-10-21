//
//  UserAPIServiceTests.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 19/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - UserAPIServiceTests

import XCTest

@testable import TinyCore

internal final class UserAPIServiceTests: XCTestCase {

    // MARK: User

    internal final func testReadUserById() {

//        let promise = expectation(description: "Read user by the given id.")
//
//        // swiftlint:disable nesting
//        struct Data {
//
//            let user: User
//
//            let accessToken: AccessTokenCredentials
//
//        }
//        // swiftlint:enable nesting
//
//        let data = Data(
//            user: User(
//                id: UserID("1"),
//                name: "Roy"
//            ),
//            accessToken: AccessTokenCredentials(
//                grantType: .jwt,
//                token: "abcd1234"
//            )
//        )
//
//        do {
//
//            let json = try JSONEncoder().encode(data.user)
//
//            let provider = StubPasswordAuthProvider(
//                result: .success(data.accessToken)
//            )
//
//            provider.authenticate(
//                credentials: PasswordCredentials(
//                    username: "bar@foo.com",
//                    password: "password"
//                ),
//                completion: { result in
//
//                    switch result {
//
//                    case .success(let auth):
//
//                        let service: UserAPIService = APIService(
//                            auth: auth,
//                            client: StubHTTPClient(data: json)
//                        )
//
//                        service.readUser(id: data.user.id) { result in
//
//                            promise.fulfill()
//
//                            switch result {
//
//                            case .success(let user):
//
//                                XCTAssertEqual(
//                                    user,
//                                    data.user
//                                )
//
//                            case .failure(let error):
//
//                                XCTFail("\(error)")
//
//                            }
//
//                        }
//
//                    case .failure(let error):
//
//                        promise.fulfill()
//
//                        XCTFail("\(error)")
//
//                    }
//
//                }
//            )
//
//            wait(
//                for: [ promise ],
//                timeout: 10.0
//            )
//
//        }
//        catch { XCTFail("\(error)") }

    }

}
