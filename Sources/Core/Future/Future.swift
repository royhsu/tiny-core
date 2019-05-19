//
//  Future.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/5/19.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - Future

public class Future<Success, Failure: Error> {
    
    /// Never to call resolve directly.
    /// Please see `map(:)`, `flatMap(:)` or `await(completion:)` instead.
    func _resolve(completion: @escaping (Result<Success, Failure>) -> Void) {
        
        fatalError("Subclasses must override this method and provide an implementation.")
        
    }
    
}

extension Future {
    
    /// Call this method will trigger resolving.
    ///
    /// - Parameter completion: The completion block.
    public func await(
        completion: @escaping (Result<Success, Failure>) -> Void = { _ in }
    ) { _resolve(completion: completion) }

}
