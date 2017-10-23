//
//  AccessTokenCredentials.swift
//  TinyCore
//
//  Created by Roy Hsu on 23/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - AccessTokenCredentials

public struct AccessTokenCredentials: Credentials {

    // MARK: Property

    public let token: String

    public let tokenType: AccessTokenType

    // MARK: Init

    public init(
        token: String,
        tokenType: AccessTokenType
    ) {

        self.token = token

        self.tokenType = tokenType

    }

}
