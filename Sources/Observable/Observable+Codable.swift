//
//  Observable+Codable.swift
//  TinyCore
//
//  Created by Roy Hsu on 2018/11/8.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - Encodable

extension Observable: Encodable where Value: Encodable {

    public func encode(to encoder: Encoder) throws {

        var container = encoder.singleValueContainer()

        if let value = value {

            try container.encode(value)

            return

        }

        try container.encodeNil()

    }

}

// MARK: - Decodable

extension Observable: Decodable where Value: Decodable {

    public init(from decoder: Decoder) throws {

        let container = try decoder.singleValueContainer()

        self.init()

        self.value = try container.decode(Value.self)

    }

}
