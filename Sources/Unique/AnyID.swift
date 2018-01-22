//
//  AnyID.swift
//  TinyCore
//
//  Created by Roy Hsu on 22/01/2018.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - AnyID

/// The type erasure wrapper for ID.
public struct AnyID<R: RawRepresentable> {

    private let base: R

    public init(_ base: R) { self.base = base }

}

// MARK: - ID

extension AnyID: ID {

    public typealias RawValue = R

    public var rawValue: R { return base }

    public init?(rawValue: RawValue) { self.init(rawValue) }

}
