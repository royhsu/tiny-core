//
//  Observation.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/2/23.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - Observation

final class _Observation<Value>: Observation {

    private let queue: DispatchQueue

    private let observer: (ObservedChange<Value>) -> Void

    init(
        queue: DispatchQueue,
        observer: @escaping (ObservedChange<Value>) -> Void
    ) {

        self.queue = queue

        self.observer = observer

    }

    func notify(with change: ObservedChange<Value>) {
        
        // Prevent the queue being deallocated before notifying the change.
        DispatchQueue.global(qos: .userInteractive).async {
            
            self.queue.async { self.observer(change) }

        }

    }

}
