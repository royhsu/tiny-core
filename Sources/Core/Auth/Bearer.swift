//
//  Bearer.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/3/16.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - Bearer

public struct Bearer {

    public var token: String

    public init(token: String) { self.token = token }

}

// MARK: - Equatable

extension Bearer: Equatable { }
