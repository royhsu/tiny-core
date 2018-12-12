//
//  DataDecoder.swift
//  TinyCore
//
//  Created by Roy Hsu on 19/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - DataDecoder

public protocol DataDecoder {

    func decode<T: Decodable>(
        _ type: T.Type,
        from data: Data
    )
    throws -> T

}

extension DataDecoder {

    func decode<T: Decodable>(
        _ type: T.Type,
        from result: Result<Data>
    )
    throws -> T {

        let data = try result.get()

        return try decode(
            T.self,
            from: data
        )

    }

}
