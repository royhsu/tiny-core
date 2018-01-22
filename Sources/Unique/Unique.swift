//
//  Unique.swift
//  TinyCore
//
//  Created by Roy Hsu on 17/07/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - Unique

public protocol Unique {

    // swiftlint:disable type_name
    associatedtype R: RawRepresentable
    // swiftlint:enable type_name

    var id: AnyID<R> { get }

}

// MARK: - Equatable (Default Implementation)

public extension Unique where R: Equatable {

    // swiftlint:disable operator_whitespace
    public static func ==(
        lhs: Self,
        rhs: Self
    )
    -> Bool { return lhs.id == rhs.id }
    // swiftlint:enable operator_whitespace

}
