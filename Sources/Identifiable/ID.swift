//
//  ID.swift
//  TinyCore
//
//  Created by Roy Hsu on 17/07/2017.
//
//

// MARK: - ID

protocol ID: Hashable {

    // MARK: Property

    associatedtype RawValue: ExpressibleByStringLiteral, Comparable, Hashable, CustomStringConvertible

    var rawValue: RawValue { get }

}

// MARK: - Equatable

extension ID {

    public static func == (lhs: Self, rhs: Self) -> Bool {

        return lhs.rawValue == rhs.rawValue

    }

}

// MARK: - Hashable

extension ID {

    public var hashValue: Int { return rawValue.hashValue }

}

// MARK: - CustomStringConvertible

extension ID {

    public var description: String { return rawValue.description }

}
