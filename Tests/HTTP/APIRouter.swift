//
//  APIRouter.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 19/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - APIRouter

import TinyCore

internal enum APIRouter: Router {

    // MARK: Case

    case readUser(
        id: UserID,
        auth: Auth
    )

    // MARK: Router

    internal func makeURLRequest() throws -> URLRequest {

        switch self {

        case .readUser(let id, let auth):

            let url = URL(string: "http://api.foo.com/users/\(id.rawValue)")!

            var request = URLRequest(url: url)

            switch auth.credentials.grantType {

            case .password:

                guard
                    let credentials = auth.credentials as? PasswordCredentials,
                    let data = "\(credentials.username):\(credentials.password)".data(using: .utf8)
                else {

                    // Todo: (version: 0.4.0, priority: .high)
                    // 1. error handling.

                    return request

                }

                let value = data.base64EncodedString()

                request.setValue(
                    "Basic \(value)",
                    forHTTPHeaderField: "Authorization"
                )

            case .jwt:

                guard
                    let credentials = auth.credentials as? AccessTokenCredentials
                else {

                    // Todo: (version: 0.4.0, priority: .high)
                    // 1. error handling.

                    return request

                }

                request.setValue(
                    "Bearer \(credentials.token)",
                    forHTTPHeaderField: "Authorization"
                )

            }

            return request

        }

    }

}
