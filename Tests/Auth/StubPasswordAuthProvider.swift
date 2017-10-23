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

    internal let result: Result<BasicAuthCredentials>

    // MARK: Init

    internal init(result: Result<BasicAuthCredentials>) {

        self.result = result

    }

    // MARK: BasicAuthProvider

    func authenticate(
        credentials: BasicAuthCredentials,
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
