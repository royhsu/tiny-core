//
//  Pool.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/2/18.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - Pool

/// The pool keeps objects for reuse to reduce object allocation.
public final class Pool<Identifier, Object>
where
    Identifier: Hashable,
    Object: AnyObject {

    private(set) var activeObjectStorage: [Identifier: Object] = [:]

    private(set) var inactiveObjects: [Object] = []

    private let objectGenerator: (Identifier) throws -> Object

    public init(
        objectGenerator: @escaping (Identifier) throws -> Object
    ) { self.objectGenerator = objectGenerator }

}

extension Pool {

    /// The pool will try to re-use an object whenever possible.
    /// It's going to look up either in an active / inactive object.
    /// If the pool can't resolve an object for the given identifier, it will call the generator to produce one.
    /// Make sure to re-configure the dequeued objects to clean up the previous states
    /// stored in them due to recycling mechanism.
    public func dequeue(for identifier: Identifier) throws -> Object {

        if let activeElement = activeObjectStorage[identifier] { return activeElement }

        if !inactiveObjects.isEmpty {

            let inactiveElement = inactiveObjects.removeFirst()

            activeObjectStorage[identifier] = inactiveElement

            return inactiveElement

        }

        let newElement = try objectGenerator(identifier)

        activeObjectStorage[identifier] = newElement

        return newElement

    }

}

extension Pool {

    /// Call this method will make all active objects enter the inactive state and wait for reuse,
    public func recycle() {

        inactiveObjects = activeObjectStorage.values.map { $0 }

        activeObjectStorage = [:]

    }

}
