//
//  EventManager.swift
//  TinyCore
//
//  Created by Roy Hsu on 19/01/2018.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - EventManager

public final class EventManager<
    E: Event,
    Listener: AnyObject
>
where E: Hashable {

    public typealias Emitter = AnyEventEmitter<Listener>

    private final var events: [E: Emitter] = [:]

}

public extension EventManager {

    @discardableResult
    public final func on(
        _ event: E,
        emit: @escaping (Listener) -> (Emitter) -> Void,
        to listener: Listener
    )
    -> EventManager {

        let emitter = AnyEventEmitter(
            listener: listener,
            emit: emit
        )

        events[event] = emitter

        return self

    }

    @discardableResult
    public final func removeListener(for event: E) -> EventManager {

        events[event] = nil

        return self

    }

}

public extension EventManager {

    public final func emit(for event: E) {

        guard
            let emitter = events[event]
        else { return }

        emitter.emit(by: emitter)

    }

}
