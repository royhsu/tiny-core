//
//  HTTPBodyEncoder.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/2/12.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - HTTPBodyEncoder

public protocol HTTPBodyEncoder {

    func encode<T>(_ value: T) throws -> Data where T: Encodable

}
