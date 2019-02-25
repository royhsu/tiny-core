//
//  Countable.swift
//  TinyCore
//
//  Created by Roy Hsu on 2018/12/12.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - Countable

public protocol Countable {

    var count: Int { get }

}

// MARK: - String

extension String: Countable { }

// MARK: - Array

extension Array: Countable { }

// MARK: - Set

extension Set: Countable { }

// MARK: - Dictionary

extension Dictionary: Countable { }
