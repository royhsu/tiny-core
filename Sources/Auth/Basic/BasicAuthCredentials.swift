//
//  BasicAuthCredentials.swift
//  TinyCore
//
//  Created by Roy Hsu on 20/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - BasicAuthCredentials

public struct BasicAuthCredentials: Credentials {

    // MARK: Property

    public let username: String

    public let password: String

}

// MARK: - Equatable

extension BasicAuthCredentials: Equatable {

    public static func ==(
        lhs: BasicAuthCredentials,
        rhs: BasicAuthCredentials
    )
    -> Bool {

        return lhs.username == rhs.username
            && lhs.password == rhs.password

    }

}
