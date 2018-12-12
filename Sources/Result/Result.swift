//
//  Result.swift
//  TinyCore
//
//  Created by Roy Hsu on 19/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - Result

public enum Result<Success> {

    case success(Success)

    case failure(Error)

}

public extension Result {

    public func get() throws -> Success {

        switch self {

        case let .success(success): return success

        case let .failure(failure): throw failure

        }

    }

}
