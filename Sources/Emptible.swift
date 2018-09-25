//
//  Emptible.swift
//  TinyCore
//
//  Created by Roy Hsu on 2018/9/25.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - Emptible

public protocol Emptible {

    var isEmpty: Bool { get }

}

// MARK: - String

extension String: Emptible { }

// MARK: - Array

extension Array: Emptible { }

// MARK: - Set

extension Set: Emptible { }

// MARK: - Dictionary

extension Dictionary: Emptible { }
