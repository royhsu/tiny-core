//
//  Property.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/1/18.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - Property

public final class Property<Value> {

    let boardcaster = Broadcaster<Value?>()

    private let _storage: Atomic<Storage>

    public init(_ initialValue: Value? = nil) {

        guard let initialValue = initialValue else {
            
            self._storage = Atomic( Storage(value: nil, isInitialValue: true) )
            
            return
            
        }
        
        self._storage = Atomic(
            Storage(value: initialValue, isInitialValue: false)
        )

    }

}

extension Property {
    
    public var value: Value? {
        
        get { return _storage.value.value }
        
        set { modify { $0 = newValue } }
        
    }
    
    public var createdDate: Date { return _storage.createdDate }
    
    public var modifiedDate: Date{ return _storage.modifiedDate }

    public func modify(_ closure: @escaping (inout Value?) -> Void) {

        _storage.modify { [weak self] storage in

            let oldValue = storage.value
            
            closure(&storage.value)

            let newValue = storage.value

            let change: ObservedChange =
                storage.isInitialValue
                ? .initial(value: newValue)
                : .changed(oldValue: oldValue, newValue: newValue)

            if storage.isInitialValue { storage.isInitialValue = false }

            self?.boardcaster.notifyAll(with: change)

        }

    }

}

// MARK: - Storage

extension Property {
    
    private struct Storage {
        
        var value: Value?
        
        var isInitialValue: Bool
        
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
