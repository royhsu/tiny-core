//
//  Radian.swift
//  TinyCore
//
//  Created by Roy Hsu on 2018/4/5.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - Radian

public struct Radian: RawRepresentable {

    public var rawValue: Double

    public init(rawValue: Double) { self.rawValue = rawValue }

}

// MARK: - Numeric

extension Radian: Numeric {

    public init?<T>(exactly source: T) where T: BinaryInteger {

        guard
            let value = Double(exactly: source)
        else { return nil }

        self.init(rawValue: value)

    }

    public init(integerLiteral value: Double) { self.init(rawValue: value) }

    public var magnitude: Double { return rawValue.magnitude }

    public static func + (
        lhs: Radian,
        rhs: Radian
    )
    -> Radian { return Radian(rawValue: lhs.rawValue + rhs.rawValue) }

    public static func += (
        lhs: inout Radian,
        rhs: Radian
    ) { lhs.rawValue += rhs.rawValue }

    public static func - (
        lhs: Radian,
        rhs: Radian
    )
    -> Radian { return Radian(rawValue: lhs.rawValue - rhs.rawValue) }

    public static func -= (
        lhs: inout Radian,
        rhs: Radian
    ) { lhs.rawValue -= rhs.rawValue }

    public static func * (
        lhs: Radian,
        rhs: Radian
    )
    -> Radian { return Radian(rawValue: lhs.rawValue * rhs.rawValue) }

    public static func *= (
        lhs: inout Radian,
        rhs: Radian
    ) { lhs.rawValue *= rhs.rawValue }

}

// MARK: - ExpressibleByFloatLiteral

extension Radian: ExpressibleByFloatLiteral {

    public init(floatLiteral value: Double) { self.init(rawValue: value) }

}
