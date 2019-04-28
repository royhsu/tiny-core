//
//  Property+Observable.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/3/22.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - Observable

extension Property: Observable {

    public func observe(
        on queue: DispatchQueue = .global(),
        observer: @escaping (ObservedChange<Value?>) -> Void
    )
    -> Observation {

        return boardcaster.observe(
            on: queue,
            observer: observer
        )

    }

}
