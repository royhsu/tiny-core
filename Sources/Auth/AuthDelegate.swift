//
//  AuthDelegate.swift
//  TinyCore
//
//  Created by Roy Hsu on 21/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - AuthDelegate

public protocol AuthDelegate: class {

    // MARK: Property

    /// The granted auth from the given provider.
    /// About how to grant an auth, please see the function requestAuth(credentials:completion:) for more information.
    var grantedAuth: Auth? { get set }

    /// Which type of provider for requesting an auth.
    var providerType: AuthProvider.Type { get }

    // MARK: Request Auth

    /// Call this function to request an auth with proper credentials.
    /// If you decide to implement this instead of using the default implemented one, please make sure to reference the property grantedAuth to the auth of result.
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
