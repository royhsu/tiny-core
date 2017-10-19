//
//  ModelDecoder.swift
//  TinyCore
//
//  Created by Roy Hsu on 19/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - ModelDecoder

public protocol ModelDecoder {

    func decode<T>(
        _ type: T.Type,
        from data: Data
    )
    throws -> T
    where T: Decodable

}
