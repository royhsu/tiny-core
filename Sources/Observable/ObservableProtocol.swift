//
//  ObservableProtocol.swift
//  TinyCore
//
//  Created by Roy Hsu on 2018/9/22.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - ObservableProtocol

public protocol ObservableProtocol: AnyObject {

    associatedtype Value

    var value: Value? { get set }

    func observe(
        _ observer: @escaping (_ change: ObservedChange<Value>) -> Void
    )
    -> Observation

}

// MARK: - AnyObservable

public final class AnyObservable<Value>: ObservableProtocol {

    private final let _getValue: () -> Value?

    private final let _setValue: (Value?) -> Void

    private final let _observe: (
        _ observer: @escaping (_ change: ObservedChange<Value>) -> Void
    )
    -> Observation

    public init<O: ObservableProtocol>(_ observable: O) where O.Value == Value {

        self._getValue = { observable.value }

        self._setValue = { newValue in observable.value = newValue }

        self._observe = observable.observe

    }

    public final var value: Value? {

        get { return _getValue() }

        set { _setValue(newValue) }

    }

    public final func observe(
        _ observer: @escaping (_ change: ObservedChange<Value>) -> Void
    )
    -> Observation { return _observe(observer) }

}
