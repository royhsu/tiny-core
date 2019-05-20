//
//  Future.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/5/19.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - Future

/// A future represents a deferred result that will be resolved by a promise.
/// Meant to be composed by functional style `map(:)`, `flatMap(:)`, etc.
/// NOTE: It's important to call `await(completion:)` to trigger resolving.
public class Future<Success, Failure> where Failure: Error {
    
    /// Never to call this method directly.
    /// Please see `map(:)`, `flatMap(:)` or `await(completion:)` instead.
    func _resolve(completion: @escaping (Result<Success, Failure>) -> Void) {
        
        fatalError("Subclasses must override this method and provide an implementation.")
        
    }
    
}

extension Future {
    
    /// Call this method will trigger resolving. Should be always put at the end of mapping chain.
    ///
    /// - Parameter completion: The completion block.
    public func await(
        completion: @escaping (Result<Success, Failure>) -> Void = { _ in }
    ) { _resolve(completion: completion) }

}

extension Future {
    
    public func map<NewSuccess>(
        _ transform: @escaping (Success) -> NewSuccess
    )
    -> Future<NewSuccess, Failure> {
        
        return Promise { completion in
                
            self._resolve { result in completion(result.map(transform)) }
            
        }
            
    }
    
    public func flatMap<NewSuccess>(
        _ transform: @escaping (Success) -> Future<NewSuccess, Failure>
    )
    -> Future<NewSuccess, Failure> {
        
        return Promise { completion in
                
            self._resolve { result in
                
                do {
                    
                    let success = try result.get()
                    
                    let newFuture = transform(success)
                    
                    newFuture.await(completion: completion)
                    
                }
                catch { completion(.failure(error as! Failure)) }
                
            }
            
        }
            
    }
    
}

extension Future {
    
    public func mapError<NewFailure>(
        _ transform: @escaping (Failure) -> NewFailure
    )
    -> Future<Success, NewFailure>
    where NewFailure: Error {
        
        return Promise { completion in
            
            self._resolve { result in completion(result.mapError(transform)) }
            
        }
            
    }
    
    public func flatMapError<NewFailure>(
        _ transform: @escaping (Failure) -> Future<Success, NewFailure>
    )
    -> Future<Success, NewFailure>
    where NewFailure: Error {
        
        return Promise { completion in
            
            self._resolve { result in
                
                do {
                    
                    let success = try result.get()
                    
                    completion(.success(success))
                    
                }
                catch {
                    
                    let newFuture = transform(error as! Failure)
                    
                    newFuture.await(completion: completion)
                    
                }
                
            }
            
        }
            
    }
    
}
