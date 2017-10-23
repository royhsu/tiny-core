//
//  StubBasicAuthProviderr.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 20/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - StubBasicAuthProvider

import TinyCore

internal struct StubBasicAuthProvider: BasicAuthProvider {

    // MARK: Property

    internal static var stubResult: Result<Auth>?

    // MARK: BasicAuthProvider

    internal static func authenticate(
        credentials: BasicAuthCredentials,
        completion: @escaping (Result<Auth>) -> Void
    ) {

        guard
            let result = stubResult
        else {

            completion(
                .failure(AuthError.credentialsNotFound)
            )

            return

        }

        completion(result)

    }

}
