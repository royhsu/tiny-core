//
//  Mapper.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/5/18.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - Mapper

public struct Mapper<State, NewState> {
    
    public typealias Transform = (
        _ fromState: State,
        _ completion: @escaping (NewState) -> Void
    )
    -> Void
    
    private let transform: Transform
    
    public init(transform: @escaping Transform) { self.transform = transform }
    
}

extension Mapper {
    
    public func map(
        _ fromState: State,
        completion: @escaping (NewState) -> Void
    ) { transform(fromState, completion) }
    
}

// MARK: - Reducer

extension Mapper: Reducer where State == NewState {
    
    public func reduce(
        _ initialState: State,
        completion: @escaping (State) -> Void
    ) { map(initialState, completion: completion) }
    
}
