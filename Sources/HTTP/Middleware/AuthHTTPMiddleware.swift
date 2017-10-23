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

        var request = request

        if
            let credentials = authDelegate.grantedAuth?.credentials as? BasicAuthCredentials,
            let data = "\(credentials.username):\(credentials.password)".data(using: .utf8) {

            let value = data.base64EncodedString()

            request.setValue(
                "Basic \(value)",
                forHTTPHeaderField: "Authorization"
            )

            return (request, completion)

        }
        
        if
            let credentials = authDelegate.grantedAuth?.credentials as? AccessTokenCredentials {
            
            request.setValue(
                "Bearer \(credentials.token)",
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
