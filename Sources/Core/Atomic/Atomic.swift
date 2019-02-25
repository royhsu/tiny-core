//
//  Atomic.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/1/18.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - Atomic

public final class Atomic<Value> {

    /// Note: lazy var is not thread safe.
    /// See discussion [Make "lazy var" threadsafe](https://bugs.swift.org/browse/SR-1042) for more detail.
    private let queue: DispatchQueue

    private var _value: Value

    public init(value: Value) {

        self._value = value

        let id = UUID()

        let dynamicType = String(describing: type(of: self) )

        self.queue = DispatchQueue(
            label: "\(dynamicType).ConcurrentQueue.\(id)",
            attributes: .concurrent
        )

    }

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

// MARK: - Codable

extension Atomic: Codable where Value: Codable {

    public convenience init(from decoder: Decoder) throws {

        let container = try decoder.singleValueContainer()

        let value = try container.decode(Value.self)

        self.init(value: value)

    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.singleValueContainer()

        try container.encode(value)

    }

}
