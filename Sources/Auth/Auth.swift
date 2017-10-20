//
//  Auth.swift
//  TinyCore
//
//  Created by Roy Hsu on 20/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - Auth

public struct Auth {

    // MARK: Property

    public let credentials: Credentials

    public let provider: AuthProvider

    // MARK: Init

    public init(
        credentials: Credentials,
        provider: AuthProvider
    ) {

        self.credentials = credentials

        self.provider = provider

    }

}
