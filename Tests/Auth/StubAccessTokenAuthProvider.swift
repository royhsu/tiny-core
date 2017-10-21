//
//  StubAccessTokenAuthProvider.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 21/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - StubPasswordAuthProvider

import TinyCore

internal final class StubAccessTokenAuthProvider: PasswordAuthProvider {

    // MARK: Property

    internal final let result: Result<AccessTokenCredentials>

    // MARK: Init

    internal init(result: Result<AccessTokenCredentials>) {

        self.result = result

    }

    // MARK: PasswordAuthProvider

    func authenticate(
        credentials: PasswordCredentials,
        completion: @escaping (Result<Auth>) -> Void
        ) {

        switch result {

        case .success(let credentials):

            let auth = Auth(
                credentials: credentials,
                provider: self
            )

            completion(
                .success(auth)
            )

        case .failure(let error):

            completion(
                .failure(error)
            )

        }

    }

}
