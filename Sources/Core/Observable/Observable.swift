//
//  Observable.swift
//  TinyCore
//
//  Created by Roy Hsu on 17/03/2018.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - Observable

public protocol Observable {

    associatedtype ObservedChange: ObservedChangeProtocol
    
    var value: ObservedChange.Value? { get }

    func observe(
        on queue: DispatchQueue,
        observer: @escaping (ObservedChange) -> Void
    )
    -> Observation

}
