//
//  Future.swift
//  TinyCore
//
//  Created by Roy Hsu on 22/01/2018.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - FutureContext

public protocol FutureContext { }

// MARK: - Future

public protocol Future {
    
    @discardableResult
    func then<T, N>(
        in context: FutureContext?,
        handler: @escaping (T) throws -> N
    )
    -> Future
    
    @discardableResult
    func `catch`(
        in context: FutureContext?,
        handler: @escaping (Error) throws -> Void
    )
    -> Future
    
}

extension Future {
    
    @discardableResult
    public func then<T, N>(
        handler: @escaping (T) throws -> N
    )
    -> Future {
        
        return self.then(
            in: nil,
            handler: handler
        )
        
    }
    
    @discardableResult
    func `catch`(
        handler: @escaping (Error) throws -> Void
    )
    -> Future {
        
        return self.catch(
            in: nil,
            handler: handler
        )
        
    }
    
}

//public struct AnyFuture {
//
//    private let base: Future
//
//    public init(_ base: Future) { self.base = base }
//
//}
//
//extension AnyFuture: Future {
//
//    public func then<T>(
//        in context: FutureContext,
//        handler: (T) -> Void
//    )
//    -> Future {
//
//        return base.then(
//            in: context,
//            handler: handler
//        )
//
//    }
//
//    public func `catch`(
//        in context: FutureContext,
//        handler: (Error) -> Void
//    )
//    -> Future {
//
//        return base.then(
//            in: context,
//            handler: handler
//        )
//
//    }
//
//}

