//
//  User.swift
//  TinyCore
//
//  Created by Roy Hsu on 22/01/2018.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - User

import TinyCore

internal struct User: Unique {

    // swiftlint:disable type_name
    internal typealias ID = UserID
    // swiftlint:enable type_name

    internal let id: AnyID<ID>

    internal init(id: ID) { self.id = AnyID(id) }

}

extension User: Equatable { }
