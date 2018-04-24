//
//  EventEmitterTests.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 23/01/2018.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - EventManagerTests

import XCTest

@testable import TinyCore

internal final class EventEmitterTests: XCTestCase {

    internal typealias Emitter = EventEmitter<TrafficLight>

    internal typealias Listening = Emitter.Listening

    internal final var greenListening: Listening?

    internal final var redListening: Listening?

    internal final var yellowListening: Listening?

    internal final override func tearDown() {

        greenListening = nil

        redListening = nil

        yellowListening = nil

        super.tearDown()

    }

    internal final func testListeningEvent() {

        let greenPromise = expectation(description: "Listening the traffic light for green.")

        let redPromise = expectation(description: "Listening the traffic light for red.")

        let yellowPromise = expectation(description: "Listening the traffic light for yellow.")

        let emitter = Emitter()

        greenListening = emitter.listen(event: .green) { _, light in

            greenPromise.fulfill()

            XCTAssertEqual(
                light,
                .green
            )

        }

        redListening = emitter.listen(event: .red) { _, light in

            redPromise.fulfill()

            XCTAssertEqual(
                light,
                .red
            )

        }

        yellowListening = emitter.listen(event: .yellow) { _, light in

            yellowPromise.fulfill()

            XCTAssertEqual(
                light,
                .yellow
            )

        }

        emitter.emit(event: .green)

        emitter.emit(event: .red)

        emitter.emit(event: .yellow)

        wait(
            for: [
                greenPromise,
                redPromise,
                yellowPromise
            ],
            timeout: 10.0
        )

    }

}
