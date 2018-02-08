//
//  Future.swift
//  TinyCore
//
//  Created by Roy Hsu on 22/01/2018.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - Future

public struct Future<T> {

    private let promise: Promise<T>

    public init(_ promise: Promise<T>) { self.promise = promise }

}

public extension Future {

    @discardableResult
    public func then<N>(
        in context: FutureContext,
        handler: @escaping (T) throws -> N
    )
    -> Future<N> {

        let then = promise.then(
            in: Context(context),
            handler
        )

        return Future<N>(then)

    }

    @discardableResult
    public func `catch`(
        in context: FutureContext,
        handler: @escaping (Error) throws -> Void
    )
    -> Future<Void> {

        let `catch` = promise.catch(
            in: Context(context),
            handler
        )

        return Future<Void>(`catch`)

    }
    
    @discardableResult
    public func always(
        in context: FutureContext,
        handler: @escaping () throws -> Void
    )
    -> Future<T> {
        
        let always = promise.always(
            in: Context(context),
            body: handler
        )
        
        return Future<T>(always)
        
    }

}
