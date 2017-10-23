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

    // Todo: (version: nil, priority: .medium)
    // 1. add associated user with created auth.

    // MARK: Init

    public init(credentials: Credentials) {

        self.credentials = credentials

    }

}
