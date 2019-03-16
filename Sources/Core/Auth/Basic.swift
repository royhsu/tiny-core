//
//  Basic.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/3/16.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - Basic

public struct Basic {

    public var username: String

    public var password: String

    public init(
        username: String,
        password: String
    ) {

        self.username = username

        self.password = password

    }

}

// MARK: - Equatable

extension Basic: Equatable { }
