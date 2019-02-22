//
//  Atomic.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/1/18.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - Atomic

public final class Atomic<Value> {

    private lazy var queue: DispatchQueue = {

        let id = UUID()

        let dynamicType = String(describing: type(of: self) )

        return DispatchQueue(
            label: "\(dynamicType).ConcurrentQueue.\(id)",
            attributes: .concurrent
        )

    }()

    private var _value: Value

    public init(value: Value) { self._value = value }

    /// The atomic will ensure to finish the previous writing operation before reading the underlying value.
    public var value: Value { return queue.sync { self._value } }

    /// Mutating the underlying value is an asynchronous operation so it can avoid blocking the calling thread.
    public func mutateValue(
        _ mutation: @escaping (inout Value) -> Void
    ) { queue.async(flags: .barrier) { mutation(&self._value) } }

}

// MARK: - Equatable

extension Atomic: Equatable where Value: Equatable {

    public static func == (
        lhs: Atomic,
        rhs: Atomic
    )
    -> Bool { return lhs.value == rhs.value }

}
