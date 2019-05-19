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
    /// See discussion [Make "lazy var" threadsafe](https://bugs.swift.org/browse/SR-1042) for more details.
    private let queue: DispatchQueue

    private var _storage: Storage

    public init(_ value: Value) {

        self._storage = Storage(value: value)

        let identifier = UUID()

        let dynamicType = String(describing: type(of: self))

        self.queue = DispatchQueue(
            label: "\(dynamicType).ConcurrentQueue: [\(identifier)]",
            attributes: .concurrent
        )

    }

}

extension Atomic {

    public var value: Value { return queue.sync { self._storage.value } }

    public var createdDate: Date { return queue.sync { _storage.createdDate } }

    public var modifiedDate: Date {

        return queue.sync { _storage.modifiedDate }

    }

    public func modify(_ closure: @escaping (inout Value) -> Void) {

        queue.async(flags: .barrier) {

            closure(&self._storage.value)

            self._storage.modifiedDate = Date()

        }

    }

}

// MARK: - Storage

extension Atomic {

    private struct Storage {

        var value: Value

        let createdDate: Date

        var modifiedDate: Date

        init(value: Value) {

            let date = Date()

            self.value = value

            self.createdDate = date

            self.modifiedDate = date

        }

    }

}

// MARK: - Equatable

extension Atomic: Equatable where Value: Equatable {

    public static func == (lhs: Atomic, rhs: Atomic) -> Bool {

        return lhs.value == rhs.value

    }

}
