//
//  BasicAuthCredentials+HTTP.swift
//  TinyCore
//
//  Created by Roy Hsu on 23/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - HTTP

public extension BasicAuthCredentials {

    public func valueForAuthorizationHTTPHeader() throws -> String {

        guard
            let headerData = "\(username):\(password)".data(using: .utf8)
        else { throw AuthError.invalidCredentials(self) }

        let headerValue = headerData.base64EncodedString()

        return "Basic \(headerValue)"

    }

}
