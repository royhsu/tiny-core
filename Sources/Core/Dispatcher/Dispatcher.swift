//
//  Dispatcher.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/2/22.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - Dispatcher

public final class Dispatcher<Item> {

    private let batchScheduler: AnyDispatcherBatchScheduler<Item>

    private let batchTask: (_ batchItems: [Item]) -> Void

    private lazy var batchTaskQueue: DispatchQueue = {

        let identifier = UUID()

        let typeName = String(describing: type(of: self))

        return DispatchQueue(label: "\(typeName).SerialQueue.BatchTask: [\(identifier)]")

    }()

    private let _queue = Atomic([Item]())

    public init<S>(
        batchScheduler: S,
        batchTask: @escaping (_ batchItems: [Item]) -> Void
    )
    where
        S: DispatcherBatchScheduler,
        S.Item == Item {

        self.batchScheduler = AnyDispatcherBatchScheduler(batchScheduler)

        self.batchTask = batchTask

    }

}

extension Dispatcher {

    public var queue: [Item] { return _queue.value }

    public func dispatch(_ item: Item, completion: (([Item]) -> Void)? = nil) {
        
        _queue.modify { items in
            
            var newItems = items
            
            newItems.append(item)
            
            completion?(newItems)
            
            if self.batchScheduler.shouldBatch(for: newItems) {
                
                items = []
                
                self.batchTask(newItems)
                
            }
            else { items = newItems }
            
        }
        
    }

}
