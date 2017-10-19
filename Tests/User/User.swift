//
//  User.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 19/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - User

internal struct User: Codable {

    // MARK: Property

    internal let id: UserID

    internal let name: String

}

// MARK: - Equatable

extension User: Equatable {

    // swiftlint:disable operator_whitespace
    internal static func ==(
        lhs: User,
        rhs: User
    )
    -> Bool {

        return lhs.id == rhs.id
            && lhs.name == rhs.name

    }
    // swiftlint:enable operator_whitespace

}

// MARK: - Identifiable

import TinyCore

extension User: Identifiable { }
