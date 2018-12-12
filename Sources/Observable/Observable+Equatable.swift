//
//  Observable+Equatable.swift
//  TinyCore
//
//  Created by Roy Hsu on 2018/12/12.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - Equatable

extension Observable: Equatable where Value: Equatable {

    public static func ==(
        lhs: Observable<Value>,
        rhs: Observable<Value>
    )
    -> Bool { return lhs.value == rhs.value }

}
