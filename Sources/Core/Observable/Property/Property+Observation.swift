//
//  Observation.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/2/23.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - Observation

extension Property {

    final class _Observation: Observation {

        private let queue: DispatchQueue

        private let observer: (ObservedChange) -> Void

        init(
            queue: DispatchQueue,
            observer: @escaping (ObservedChange) -> Void
        ) {

            self.queue = queue

            self.observer = observer

        }

        func notify(with change: ObservedChange) {

            queue.async { [weak self] in self?.observer(change) }

        }

    }

}
