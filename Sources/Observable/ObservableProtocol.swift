//
//  ObservableProtocol.swift
//  TinyCore
//
//  Created by Roy Hsu on 2018/9/22.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - ObservableProtocol

public protocol ObservableProtocol {

    associatedtype Value

    func setValue(_ value: Value?)

    func observe(
        _ observer: @escaping (_ change: ObservedChange<Value>) -> Void
    )
    -> Observation

}

// MARK: - AnyObservable

public struct AnyObservable<Value>: ObservableProtocol {

    private let _setValue: (Value?) -> Void

    public let _observe: (
        _ observer: @escaping (_ change: ObservedChange<Value>) -> Void
    )
    -> Observation

    public init<O: ObservableProtocol>(_ observable: O) where O.Value == Value {

        self._setValue = observable.setValue

        self._observe = observable.observe

    }

    public func setValue(_ value: Value?) { _setValue(value) }

    public func observe(
        _ observer: @escaping (_ change: ObservedChange<Value>) -> Void
    )
    -> Observation { return _observe(observer) }

}
