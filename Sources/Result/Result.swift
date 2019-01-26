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

    public init(catching body: () throws -> Success) {

        do {

            self = .success(
                try body()
            )

        }
        catch { self = .failure(error) }

    }

}

public extension Result {
    
    public func map<NewSuccess>(
        _ tranform: (Success) throws -> NewSuccess
    )
    -> Result<NewSuccess> {
        
        return Result<NewSuccess> {
            
            let success = try self.get()
            
            return try tranform(success)
            
        }
        
    }
    
    public func flatMap<NewSuccess>(
        _ transform: (Success) -> Result<NewSuccess>
    )
    -> Result<NewSuccess> {
        
        return Result<NewSuccess> {
            
            let success = try get()
            
            let newResult = transform(success)
            
            let newSuccess = try newResult.get()
            
            return newSuccess
            
        }
        
    }
    
}
