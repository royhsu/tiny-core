//
//  Broadcaster.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/2/23.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - Broadcaster

final class Broadcaster<Value> {

    typealias Object = WeakObject<_Observation<Value>>

    private(set) var objects: [Object] = []

    func observe(
        on queue: DispatchQueue,
        observer: @escaping (ObservedChange<Value>) -> Void
    )
    -> Observation {

        let observation = _Observation(queue: queue, observer: observer)

        objects.append(WeakObject(observation))

        return observation

    }

    func notifyAll(with change: ObservedChange<Value>) {

        objects.removeAll { $0.reference == nil }

        objects.forEach { $0.reference?.notify(with: change) }

    }

}
