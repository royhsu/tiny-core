//
//  PasswordCredentials.swift
//  TinyCore
//
//  Created by Roy Hsu on 20/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - PasswordCredentials

public struct PasswordCredentials: Credentials {

    // MARK: Property

    public let grantType: GrantType = .password

    public let username: String

    public let password: String

}
