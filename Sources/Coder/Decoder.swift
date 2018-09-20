//
//  Decoder.swift
//  TinyCore
//
//  Created by Roy Hsu on 19/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - Decoder

#warning("Name conflicts with the built-in one.")
public protocol Decoder {

    func decode<T: Decodable>(
        _ type: T.Type,
        from data: Data
    )
    throws -> T

}

extension Decoder {

    func decode<T: Decodable>(
        _ type: T.Type,
        from result: Result<Data>
    )
    throws -> T {

        let data = try result.resolve()

        return try decode(
            T.self,
            from: data
        )

    }

}
