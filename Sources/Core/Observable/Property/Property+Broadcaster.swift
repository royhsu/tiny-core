//
//  Broadcaster.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/2/23.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - Broadcaster

extension Property {

    final class Broadcaster {

        typealias Object = WeakObject<_Observation>

        private(set) var objects: [Object] = []

        func observe(
            on queue: DispatchQueue,
            observer: @escaping (ObservedChange) -> Void
        )
        -> Observation {

            let observation = _Observation(
                queue: queue,
                observer: observer
            )

            objects.append(
                WeakObject(observation)
            )

            return observation

        }

        func notifyAll(with change: ObservedChange) {

            let liveObjects = objects.filter { $0.reference != nil }

            objects = liveObjects

            liveObjects.forEach { $0.reference?.notify(with: change) }

        }

    }

}
