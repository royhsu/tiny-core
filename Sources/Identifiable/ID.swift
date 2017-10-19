//
//  ID.swift
//  TinyCore
//
//  Created by Roy Hsu on 17/07/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - ID

public protocol ID: Hashable, Codable {

    // MARK: Property

    associatedtype RawValue: ExpressibleByStringLiteral, Comparable, Hashable, CustomStringConvertible, Codable

    var rawValue: RawValue { get set }

    init(_ rawValue: RawValue)

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

// MARK: - CustomStringConvertible (Default Implementation)

public extension ID {

    public var description: String { return rawValue.description }

}

// MARK: - Codable (Default Implementation)

public extension ID {

    // MARK: Decodable

    public init(from coder: Decoder) throws {

        let container = try coder.singleValueContainer()

        let rawValue: RawValue = try container.decode(RawValue.self)

        self.init(rawValue)

    }

    // MARK: Encodable

    public func encode(to encoder: Encoder) throws {

        var container = encoder.singleValueContainer()

        try container.encode(rawValue)

    }

}
