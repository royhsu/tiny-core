//
//  EventEmitter.swift
//  TinyCore
//
//  Created by Roy Hsu on 19/01/2018.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - EventEmitter

public protocol EventEmitter {

    associatedtype Listener: AnyObject

    func emit(by emitter: AnyEventEmitter<Listener>)

}

// MARK: - AnyEventEmitter

public struct AnyEventEmitter<L: AnyObject>: EventEmitter {

    public typealias L = Listener

    public typealias Emit = (Listener) -> (AnyEventEmitter) -> Void

    private weak var _listener: Listener?

    private let _emit: Emit

    public init(
        listener: Listener,
        emit: @escaping Emit
    ) {

        self._listener = listener

        self._emit = emit

    }

    public func emit(by emitter: AnyEventEmitter) {

        guard
            let listenr = _listener
        else { return }

        _emit(listenr)(emitter)

    }

}
