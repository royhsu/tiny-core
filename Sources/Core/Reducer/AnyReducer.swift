//
//  AnyReducer.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/5/18.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - AnyReducer

public struct AnyReducer<State> {
    
    private let _reduce: (
        _ initialState: State,
        _ completion: @escaping (State) -> Void
    )
    -> Void
    
    public init<R>(_ reducer: R)
    where
        R: Reducer,
        R.State == State { self._reduce = reducer.reduce }
    
    public init(
        _ reduce: @escaping (
            _ initialState: State,
            _ completion: @escaping (State) -> Void
        )
        -> Void
    ) { self._reduce = reduce }
    
}

// MARK: - Reducer

extension AnyReducer: Reducer {
    
    public func reduce(
        _ initialState: State,
        completion: @escaping (State) -> Void
    ) { _reduce(initialState, completion) }
    
}
