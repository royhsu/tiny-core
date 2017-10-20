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

            let providerName: String

            let accessToken: AccessToken

        }
        // swiftlint:enable nesting

        let data = Data(
            user: User(
                id: UserID("1"),
                name: "Roy"
            ),
            providerName: "foo.com",
            accessToken: AccessToken(rawValue: "abcd1234")
        )

        do {

            let json = try JSONEncoder().encode(data.user)

            let credential = Credential.accessToken(data.accessToken)

            let provider = StubPasswordAuthProvider(
                name: data.providerName,
                result: .success(credential)
            )

            provider.signIn(
                username: "john.appleseed@test.com",
                password: "password",
                completion: { result in

                    switch result {

                    case .success(let auth):

                        XCTAssertEqual(
                            auth.provider.name,
                            provider.name
                        )

                        let service: UserAPIService = APIService(
                            auth: auth,
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

                    case .failure(let error):

                        promise.fulfill()

                        XCTFail("\(error)")

                    }

                }
            )

            wait(
                for: [ promise ],
                timeout: 10.0
            )

        }
        catch { XCTFail("\(error)") }

    }

}
