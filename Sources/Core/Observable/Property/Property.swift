//
//  Property.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/1/18.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - Property

public final class Property<Value> {

    let boardcaster = Broadcaster()

    private var isInitialValue = true
    
    private let _storage: Atomic<Value?>

    public init(value: Value? = nil) {

        if let initialValue = value {

            self._storage = Atomic(value: initialValue)

            self.isInitialValue = false

        }
        else { self._storage = Atomic(value: nil) }

    }
    
}

extension Property {

    public func mutateValue(
        _ mutation: @escaping (inout Value?) -> Void
    ) {

        _storage.mutateValue { value in

            let oldValue = value

            mutation(&value)

            let newValue = value

            let change: ObservedChange =
                self.isInitialValue
                ? .initial(value: newValue)
                : .changed(
                    oldValue: oldValue,
                    newValue: newValue
                )

            if self.isInitialValue { self.isInitialValue = false }

            self.boardcaster.notifyAll(with: change)

        }

    }

}

// MARK: - Observable

extension Property: Observable {
    
    public var value: Value? { return _storage.value }

    public func observe(
        on queue: DispatchQueue = .global(),
        observer: @escaping (ObservedChange) -> Void
    )
    -> Observation {

        return boardcaster.observe(
            on: queue,
            observer: observer
        )

    }

}

// MARK: - Equatable

extension Property: Equatable where Value: Equatable {
    
    public static func == (
        lhs: Property,
        rhs: Property
    )
    -> Bool { return lhs.value == rhs.value }
    
}

// MARK: - Codable

extension Property: Codable where Value: Codable {
    
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
