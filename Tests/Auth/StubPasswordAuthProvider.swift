//
//  StubPasswordAuthProvider.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 20/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - StubPasswordAuthProvider

import TinyCore

internal final class StubPasswordAuthProvider: PasswordAuthProvider {

    // MARK: Property

    internal final let name: String

    internal final let result: Result<Credential>

    // MARK: Init

    internal init(name: String, result: Result<Credential>) {

        self.name = name

        self.result = result

    }

    // MARK: PasswordAuthProvider

    func signIn(username: String, password: String, completion: @escaping (Result<Auth>) -> Void) {

        switch result {

        case .success(let credential):

            let auth = StubAuth(
                credential: credential,
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
