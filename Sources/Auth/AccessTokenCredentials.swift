//
//  AccessTokenCredentials.swift
//  TinyCore
//
//  Created by Roy Hsu on 20/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - AccessTokenCredentials

public struct AccessTokenCredentials: Credentials {

    // MARK: Property

    public let grantType: GrantType

    public let token: String

}