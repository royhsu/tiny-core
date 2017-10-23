//
//  AuthDelegateTests.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 23/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - AuthDelegateTests

import XCTest

@testable import TinyCore

internal final class AuthDelegateTests: XCTestCase {

    // MARK: Request Auth

    internal final func testRequestAuth() {

        let promise = expectation(description: "Request auth.")

        // swiftlint:disable nesting
        struct StubData {

            let credentials: BasicAuthCredentials

        }
        // swiftlint:enable nesting

        let stubData = StubData(
            credentials: BasicAuthCredentials(
                username: "bar@foo.com",
                password: "password"
            )
        )

        performTest {

            let delegate: AuthDelegate = StubAuthManager(
                providerType: StubBasicAuthProvider.self
            )

            StubBasicAuthProvider.stubResult = .success(
                Auth(credentials: stubData.credentials)
            )

            delegate.requestAuth(
                credentials: stubData.credentials,
                completion: { result in

                    promise.fulfill()

                    switch result {

                    case .success(let auth):

                        XCTAssertEqual(
                            (auth.credentials as? BasicAuthCredentials),
                            delegate.grantedAuth?.credentials as? BasicAuthCredentials
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
