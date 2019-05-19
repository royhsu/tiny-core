//
//  Promise.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/5/19.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - Promise

/// The primary subclass of Future.
/// Please use this to resolve futures
public final class Promise<Success, Failure: Error>: Future<Success, Failure> {
    
    private let resolver: Resolver
    
    private let state = Atomic<State>(.pending)
    
    private let completions = Atomic<[(Result<Success, Failure>) -> Void]>([])
    
    public init(_ resolver: @escaping Resolver) { self.resolver = resolver }
    
    // MARK: Future
    
    override func _resolve(
        completion: @escaping (Result<Success, Failure>) -> Void
    ) {
        
        switch state.value {
            
        case .pending:
            
            state.modify { $0 = .resolving }
            
            completions.modify { $0.append(completion) }
            
            resolver { result in
                
                self.state.modify { $0 = .resolved(result) }
                
                self.completions.modify {
                    
                    let completions = $0
                    
                    $0 = []
                    
                    for completion in completions { completion(result) }
                    
                }
                
            }
            
        case .resolving: completions.modify { $0.append(completion) }
            
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
