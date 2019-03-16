//
//  ReducibleAction.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/3/14.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - ReducibleAction

public struct ReducibleAction<Identifier, Value> where Identifier: Hashable {

    public let identifier: Identifier

    public let reducer: (
        _ currentValue: Value,
        _ reducedResult: @escaping (_ newValue: Value) -> Void
    )
    -> Void

    public init(
        identifier: Identifier,
        reducer: @escaping (
            _ currentValue: Value,
            _ reducedResult: @escaping (_ newValue: Value) -> Void
        )
        -> Void
    ) {

        self.identifier = identifier

        self.reducer = reducer

    }

}

// MARK: - ReducibleAction

extension ReducibleAction where Identifier: Initializable {

    public init(
        reducer: @escaping (
            _ currentValue: Value,
            _ reducedResult: @escaping (_ newValue: Value) -> Void
        )
        -> Void
    ) {

        self.init(
            identifier: Identifier(),
            reducer: reducer
        )

    }

}
