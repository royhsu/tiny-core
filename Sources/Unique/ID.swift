//
//  ID.swift
//  TinyCore
//
//  Created by Roy Hsu on 17/07/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - ID

/// An identifier must be unique.
public protocol ID: RawRepresentable { }

// MARK: - Equatable (Default Implementation)

public extension ID where RawValue: Equatable {

    // swiftlint:disable operator_whitespace
    public static func ==(
        lhs: Self,
        rhs: Self
    )
    -> Bool { return lhs.rawValue == rhs.rawValue }
    // swiftlint:enabled operator_whitespace

}

// MARK: - Hashable (Default Implementation)

public extension ID where RawValue: Hashable {

    public var hashValue: Int { return rawValue.hashValue }

}

// MARK: - CustomStringConvertible (Default Implementation)

public extension ID where RawValue: CustomStringConvertible {

    public var description: String { return rawValue.description }

}
