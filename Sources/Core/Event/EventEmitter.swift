//
//  EventEmitter.swift
//  TinyCore
//
//  Created by Roy Hsu on 19/01/2018.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - EventEmitter

public final class EventEmitter<Event> where Event: Hashable {

    public typealias Listener = (
        _ emitter: EventEmitter<Event>,
        _ event: Event
    )
    -> Void

    public final class Listening {

        internal let listener: Listener

        internal init(listener: @escaping Listener) { self.listener = listener }

    }

    public typealias WeakListenings = [WeakObject<Listening>]

    private final var listeningMap: [Event: WeakListenings]

    public init() { listeningMap = [:] }

}

public extension EventEmitter {

    public final func emit(event: Event) {

        // Clean up the dead objects.
        listeningMap[event] = listeningMap[event]?.filter { $0.reference != nil }

        listeningMap[event]?.forEach { listening in

            listening.reference?.listener(
                self,
                event
            )

        }

    }

}

public extension EventEmitter {

    /// A listener must keep the strong reference to the listening while observing.
    /// Removing listener is easy. Just set the reference of the listening to nil.
    public final func listen(
        event: Event,
        listener: @escaping Listener
    )
    -> Listening {

        let listening = Listening(listener: listener)

        var listenings = listeningMap[event] ?? []

        listenings.append(
            WeakObject(listening)
        )

        listeningMap[event] = listenings

        return listening

    }

}
