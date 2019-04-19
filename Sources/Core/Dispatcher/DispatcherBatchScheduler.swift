//
//  DispatcherBatchScheduler.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/2/22.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - DispatcherBatchScheduler

public protocol DispatcherBatchScheduler {
    
    associatedtype Item

    func shouldBatch(for items: [Item]) -> Bool

}

// MARK: - AnyDispatcherBatchScheduler

public struct AnyDispatcherBatchScheduler<Item> {
    
    private let _shouldBatch: ([Item]) -> Bool
    
    public init<S>(_ scheduler: S)
    where
        S: DispatcherBatchScheduler,
        S.Item == Item { self._shouldBatch = scheduler.shouldBatch }
    
}

// MARK: - DispatcherBatchScheduler

extension AnyDispatcherBatchScheduler: DispatcherBatchScheduler {
    
    public func shouldBatch(for items: [Item]) -> Bool {
    
        return _shouldBatch(items)
        
    }
    
}
