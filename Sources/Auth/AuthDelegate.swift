//
//  AuthDelegate.swift
//  TinyCore
//
//  Created by Roy Hsu on 21/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - AuthDelegate

public protocol AuthDelegate: class {

    var grantedAuth: Auth? { get set }

    var providerType: AuthProvider.Type { get }

    // MARK: Request Auth

    func requestAuth(
        credentials: Credentials,
        completion: @escaping (_ result: Result<Auth>) -> Void
    )

}

// MARK: - Request Auth (Default Implementation)

public extension AuthDelegate {

    public func requestAuth(
        credentials: Credentials,
        completion: @escaping (_ result: Result<Auth>) -> Void
    ) {

        providerType.requestAuth(
            credentials: credentials,
            completion: { result in

                switch result {

                case .success(let auth):

                    self.grantedAuth = auth

                    completion(
                        .success(auth)
                    )

                case .failure(let error):

                    completion(
                        .failure(error)
                    )

                }

            }
        )

    }

}
