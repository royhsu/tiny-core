//
//  AnyObservable.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/2/22.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - AnyObservable

public struct AnyObservable<Value> {

    private let _getter: () -> Value

    private let _observe: (
        _ queue: DispatchQueue,
        _ observer: @escaping (ObservedChange<Value>) -> Void
    )
    -> Observation

    public init<O>(_ observable: O)
    where
        O: Observable,
        O.Value == Value {

        self._getter = { observable.value }

        self._observe = observable.observe

    }

}

// MARK: - Observable

extension AnyObservable: Observable {

    public var value: Value { return _getter() }

    public func observe(
        on queue: DispatchQueue = .global(),
        observer: @escaping (ObservedChange<Value>) -> Void
    )
    -> Observation { return _observe(queue, observer) }

}
