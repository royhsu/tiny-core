//
//  ID.swift
//  TinyCore
//
//  Created by Roy Hsu on 17/07/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - ID

public protocol ID: Hashable {

    // MARK: Property

    associatedtype RawValue: ExpressibleByStringLiteral, Comparable, Hashable, CustomStringConvertible

    var rawValue: RawValue { get }

}

// MARK: - Equatable (Default Implementation)

public extension ID {

    // swiftlint:disable operator_whitespace
    public static func ==(
        lhs: Self,
        rhs: Self
    )
    -> Bool { return lhs.rawValue == rhs.rawValue }
    // swiftlint:enable operator_whitespace

}

// MARK: - Hashable (Default Implementation)

public extension ID {

    public var hashValue: Int { return rawValue.hashValue }

}

// MARK: - CustomStringConvertible

public extension ID {

    public var description: String { return rawValue.description }

}
