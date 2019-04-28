//
//  Property+Codable.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/3/22.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - Codable

extension Property: Codable where Value: Codable {

    public convenience init(from decoder: Decoder) throws {

        let container = try decoder.singleValueContainer()

        let value = try container.decode(Value.self)

        self.init(value)

    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.singleValueContainer()

        try container.encode(value)

    }

}
