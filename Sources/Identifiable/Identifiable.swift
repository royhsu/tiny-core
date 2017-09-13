//
//  Identifiable.swift
//  TinyCore
//
//  Created by Roy Hsu on 17/07/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - Identifiable

public protocol Identifiable {

    // MARK: Property

    static var identifier: String { get }

}

// MARK: - Default Implementation

public extension Identifiable {

    static var identifier: String {

        return String(describing: self)

    }

}
