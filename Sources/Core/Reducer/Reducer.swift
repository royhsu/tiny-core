//
//  Reducer.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/5/18.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - Reducer

public protocol Reducer {
    
    associatedtype State
    
    func reduce(
        _ initialState: State,
        completion: @escaping (_ finalState: State) -> Void
    )
    
}
