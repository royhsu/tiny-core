//
//  User.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 19/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - User

internal struct User {

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

extension User: Identifiable { }

// MARK: - JSONInitializable

import TinyCore

extension User: JSONInitializable {

    internal struct Schema {

        internal static let id = "id"

        internal static let name = "name"

    }

    internal init(_ json: Any) throws {

        guard
            let json = json as? [String: Any]
            else { throw JSONError.notObject }

        guard
            let id = json[Schema.id] as? String
        else { throw JSONError.missingValueFor(key: Schema.id) }

        self.id = UserID(rawValue: id)

        guard
            let name = json[Schema.name] as? String
        else { throw JSONError.missingValueFor(key: Schema.name) }

        self.name = name

    }

}
