//
//  Dispatcher.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/2/22.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - Dispatcher

public final class Dispatcher<Item> {

    private let batchScheduler: DispatcherBatchScheduler

    private let batchTask: (
        _ dispatcher: Dispatcher,
        _ batchItems: [Item]
    )
    -> Void

    private lazy var batchTaskQueue: DispatchQueue = {

        let id = UUID()

        let typeName = String(describing: type(of: self) )

        return DispatchQueue(label: "\(typeName).SerialQueue.\(id).BatchTask")

    }()

    private let _queue = Atomic(value: [Item]() )

    public init(
        batchScheduler: DispatcherBatchScheduler,
        batchTask: @escaping (
            _ manager: Dispatcher,
            _ batchItems: [Item]
        )
        -> Void
    ) {

        self.batchScheduler = batchScheduler

        self.batchTask = batchTask

        self.load()

    }

    private func load() {

        batchScheduler.scheduleTask { [weak self] _ in

            guard let self = self else { return }

            let batchItems = self.queue

            if batchItems.isEmpty { return }

            self._queue.mutateValue { $0 = [] }

            self.batchTaskQueue.async {

                self.batchTask(
                    self,
                    batchItems
                )

            }

        }

    }

}

extension Dispatcher {

    public var queue: [Item] { return _queue.value }

    public func dispatch(_ item: Item) {

        _queue.mutateValue { $0.append(item) }

    }

}

// MARK: - DispatcherBatchScheduler

public protocol DispatcherBatchScheduler {

    func scheduleTask(
        _ task: @escaping (DispatcherBatchScheduler) -> Void
    )

}
