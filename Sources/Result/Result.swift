//
//  Result.swift
//  TinyCore
//
//  Created by Roy Hsu on 19/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - Result

public enum Result<Value> {

    case success(Value)

    case failure(Error)

}

public extension Result {

    public func resolve() throws -> Value {

        switch self {

        case let .success(value): return value

        case let .failure(error): throw error

        }

    }

}
