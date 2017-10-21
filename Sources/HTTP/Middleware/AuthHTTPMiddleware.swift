//
//  AuthHTTPMiddleware.swift
//  TinyCore
//
//  Created by Roy Hsu on 21/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - AuthHTTPMiddleware

// Todo: (version: 0.4.0, priority: .high)
// 1. Should it be splitted into AuthenticationHTTPMiddleware and AuthorizationHTTPMiddleware?

public struct AuthHTTPMiddleware: HTTPMiddleware {

    // MARK: Property

    public let authDelegate: AuthDelegate

    // MARK: Init

    public init(authDelegate: AuthDelegate) {

        self.authDelegate = authDelegate

    }

    // MARK: HTTPMiddleware

    public func respond(
        to request: URLRequest,
        completion: @escaping (_ response: HTTPResponse) -> Void
    )
    -> (request: URLRequest, completion: (HTTPResponse) -> Void) {

        guard
            let auth = authDelegate.auth
        else {

            let newCompletion: (HTTPResponse) -> Void = { response in

                completion(
                    HTTPResponse.unauthorized(with: response.request)
                )

            }

            return (request, newCompletion)

        }

        var request = request

        switch auth.credentials.grantType {

        case .password:

            guard
                let credentials = auth.credentials as? PasswordCredentials,
                let data = "\(credentials.username):\(credentials.password)".data(using: .utf8)
            else { fatalError("The grant type doesn't match the credentials.") }

            let value = data.base64EncodedString()

            request.setValue(
                "Basic \(value)",
                forHTTPHeaderField: "Authorization"
            )

        case .jwt:

            guard
                let credentials = auth.credentials as? AccessTokenCredentials
            else { fatalError("The grant type doesn't match the credentials.") }

            request.setValue(
                "Bearer \(credentials.token)",
                forHTTPHeaderField: "Authorization"
            )

        }

        return (request, completion)

    }

}
