//
//  Promise.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/5/19.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - Promise

public final class Promise<Success, Failure: Error>: Future<Success, Failure> {
    
    private let resolver: Resolver
    
    private let storage = Atomic(Storage())
    
    public init(_ resolver: @escaping Resolver) { self.resolver = resolver }
    
    // MARK: Future
    
    override func _resolve(
        completion: @escaping (Result<Success, Failure>) -> Void
    ) {
        
        switch storage.value.state {
            
        case .pending:
            
            storage.modify { storage in
                
                storage.state = .resolving
                
                storage.completions.append(completion)
                
            }
            
            resolver { result in
                
                self.storage.modify { storage in
                    
                    storage.state = .resolved(result)
                    
                    let completions = storage.completions
                    
                    storage.completions = []
                    
                    for completion in completions { completion(result) }
                    
                }
                
            }
            
        case .resolving: storage.modify { $0.completions.append(completion) }
            
        case let .resolved(result): completion(result)
            
        }
        
    }
    
}

// MARK: - State

extension Promise {
    
    private enum State {
        
        case pending
        
        case resolving
        
        case resolved(Result<Success, Failure>)
        
    }
    
}

// MARK: - Storage

extension Promise {
    
    private struct Storage {
        
        var state: State = .pending
        
        var completions: [(Result<Success, Failure>) -> Void] = []
        
    }
    
}

// MARK: - Resolver

extension Promise {
    
    public typealias Resolver = (
        _ completion: @escaping (Result<Success, Failure>) -> Void
    )
    -> Void
    
}
