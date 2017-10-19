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

        // swiftlint:disable nesting
        struct Data {

            let user: User

        }
        // swiftlint:enable nesting

        let data = Data(
            user: User(
                id: UserID("1"),
                name: "Roy"
            )
        )

        do {

            let json = try JSONEncoder().encode(data.user)

            let client: UserAPIClient = APIClient(
                httpClient: StubHTTPClient(
                    value: json
                )
            )

            client.readUser(id: data.user.id) { result in

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
