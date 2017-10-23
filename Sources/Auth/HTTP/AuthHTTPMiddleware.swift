//
//  AuthHTTPMiddleware.swift
//  TinyCore
//
//  Created by Roy Hsu on 21/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - AuthHTTPMiddleware

public struct AuthHTTPMiddleware: HTTPMiddleware {

    // MARK: Property

    /// Please make sure not to implement the auth delegate with the middleware self.
    /// Should thing of deeply if marks it as weak to avoid retain cycle.
    // swiftlint:disable weak_delegate
    public let authDelegate: AuthDelegate
    // swiftlint:enable weak_delegate

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

        var request = request

        if
            let credentials = authDelegate.grantedAuth?.credentials as? BasicAuthCredentials,
            let authorizationValue = try? credentials.valueForAuthorizationHTTPHeader() {

            request.setValue(
                authorizationValue,
                forHTTPHeaderField: "Authorization"
            )

            return (request, completion)

        }

        if
            let credentials = authDelegate.grantedAuth?.credentials as? AccessTokenCredentials,
            let authorizationValue = try? credentials.valueForAuthorizationHTTPHeader() {

            request.setValue(
                authorizationValue,
                forHTTPHeaderField: "Authorization"
            )

            return (request, completion)

        }

        let newCompletion: (HTTPResponse) -> Void = { response in

            completion(
                HTTPResponse.unauthorized(with: response.request)
            )

        }

        return (request, newCompletion)

    }

}
