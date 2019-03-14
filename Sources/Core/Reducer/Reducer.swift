//
//  Reducer.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/3/14.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - Reducer

public final class Reducer<Identifier, Value> where Identifier: Hashable {
    
    private let storage: Atomic<Storage>
    
    public init(
        initialValue: Value,
        actions: [Action] = []
    ) {
        
        self.storage = Atomic(
            value: Storage(
                currentValue: initialValue,
                actions: actions
            )
        )
        
    }
    
}

// MARK: - Action

extension Reducer {
    
    public typealias Action = ReducibleAction<Identifier, Value>
    
}

extension Reducer {
    
    public func reduce(completion: @escaping (Reducer) -> Void) {
        
        if isReducing { fatalError("The reducer must not reduce itself while it's reducing.") }
        
        storage.mutateValue { [weak self] in
            
            $0.isReducing = true
            
            $0.completion = completion
            
            $0.pendingActions = $0.actions
            
            self?.reducePendingActions()
            
        }
        
    }
    
    private func reducePendingActions() {
        
        let areAllPendingActionsReduces = storage.value.pendingActions.isEmpty
        
        if areAllPendingActionsReduces { complete(); return }
        
        storage.mutateValue { [weak self] storage in
            
            guard let self = self else { return }
            
            let nextAction = storage.pendingActions.removeFirst()
            
            nextAction.handler(storage.currentValue) { newValue in
                
                self.storage.mutateValue { storage in
                    
                    storage.currentValue = newValue
                    
                    self.reducePendingActions()
                    
                }
                
            }
            
        }
        
    }
    
    private func complete() {
        
        storage.mutateValue { [weak self] in
            
            guard let self = self else { return }
            
            $0.isReducing = false
            
            let completion = $0.completion
            
            $0.completion = nil
            
            completion?(self)
            
        }
        
    }
    
}

extension Reducer {
    
    public var isReducing: Bool { return storage.value.isReducing }
    
    public var currentValue: Value { return storage.value.currentValue }
    
    public var actions: [Action] {
        
        get { return storage.value.actions }
        
        set { storage.mutateValue { $0.actions.append(contentsOf: newValue) } }
        
    }
    
    var pendingActions: [Action] { return storage.value.pendingActions }
    
}

// MARK: - Storage

extension Reducer {
    
    private struct Storage {
        
        var isReducing = false
        
        var currentValue: Value
        
        var actions: [Action]
        
        var pendingActions: [Action] = []
        
        var completion: ( (Reducer) -> Void )?
        
        init(
            currentValue: Value,
            actions: [Action]
        ) {
            
            self.currentValue = currentValue
            
            self.actions = actions
            
        }
        
    }
    
}

// MARK: - ReducibleAction

public struct ReducibleAction<Identifier, Value> where Identifier: Hashable {
    
    public let identifier: Identifier
    
    public let handler: (
        _ currentValue: Value,
        _ newValueGenerator: @escaping (_ newValue: Value) -> Void
    )
    -> Void
    
    public init(
        identifier: Identifier,
        handler: @escaping (
            _ currentValue: Value,
            _ newValueGenerator: @escaping (_ newValue: Value) -> Void
        )
        -> Void
    ) {
        
        self.identifier = identifier
        
        self.handler = handler
        
    }

}
