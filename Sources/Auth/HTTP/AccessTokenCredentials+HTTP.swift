//
//  AccessTokenCredentials+HTTP.swift
//  TinyCore
//
//  Created by Roy Hsu on 23/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - HTTP

public extension AccessTokenCredentials {

    public func valueForAuthorizationHTTPHeader() throws -> String {

        return "\(tokenType.rawValue.capitalized) \(token)"

    }

}
