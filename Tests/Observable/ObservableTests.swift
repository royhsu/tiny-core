//
//  ObservableTests.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 2018/9/11.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - ObservableTests

import XCTest

@testable import TinyCore

internal final class ObservableTests: XCTestCase {

    internal final var observation: Observation?

    internal final func testInitialize() {

        let observable = Observable<String>()

        XCTAssertNil(observable.value)

    }

    internal final func testSetInitialValue() {

        let promise = expectation(description: "Get notified about value changes.")

        var observable = Observable<String>()

        observation = observable.observe { change in

            promise.fulfill()

            switch change {

            case let .initial(newValue):

                XCTAssertEqual(
                    newValue,
                    "hello"
                )

            case .changed: XCTFail("Must be the initial value change.")

            }

        }

        observable.value = "hello"

        XCTAssertEqual(
            observable.value,
            "hello"
        )

        wait(
            for: [ promise ],
            timeout: 10.0
        )

    }

    internal final func testSetValue() {

        let promise = expectation(description: "Get notified about value changes.")

        var observable = Observable("old value")

        observation = observable.observe { change in

            promise.fulfill()

            switch change {

            case .initial: XCTFail("Must not be the initial value change.")

            case let .changed(
                oldValue,
                newValue
            ):

                XCTAssertEqual(
                    oldValue,
                    "old value"
                )

                XCTAssertEqual(
                    newValue,
                    "new value"
                )

            }

        }

        observable.value = "new value"

        XCTAssertEqual(
            observable.value,
            "new value"
        )

        wait(
            for: [ promise ],
            timeout: 10.0
        )

    }

    internal final func testDecodable() {

        do {

            let data = try JSONSerialization.data(
                withJSONObject: [ "hello", "world" ]
            )

            let observables = try JSONDecoder().decode(
                [Observable<String>].self,
                from: data
            )

            XCTAssertEqual(
                observables.count,
                2
            )

            XCTAssertEqual(
                observables[0].value,
                "hello"
            )

            XCTAssertEqual(
                observables[1].value,
                "world"
            )

        }
        catch { XCTFail("\(error)") }

    }

    internal final func testValueBinding() {

        class Label {

            var text: String

            init(text: String) { self.text = text }

        }

        let label = Label(text: "")

        var observable = Observable("hello")

        observable.bind(
            transform: { $0 ?? "unknown" },
            to: label,
            keyPath: \.text
        )

        XCTAssertEqual(
            label.text,
            "hello"
        )

        observable.value = "world"

        XCTAssertEqual(
            label.text,
            "world"
        )

    }

    internal final func testOptionalValueBinding() {

        class Label {

            var text: String?

            init() { }

        }

        let label = Label()

        var observable = Observable("hello")

        observable.bind(
            to: label,
            keyPath: \.text
        )

        XCTAssertEqual(
            label.text,
            "hello"
        )

        observable.value = "world"

        XCTAssertEqual(
            label.text,
            "world"
        )

    }

    internal final func testEncodable() {

        let observables = [
            Observable("hello"),
            Observable("world")
        ]

        XCTAssertEqual(
            try JSONEncoder().encode(observables),
            try JSONSerialization.data(
                withJSONObject: [ "hello", "world" ]
            )
        )

    }

    internal final func testEquatable() {

        XCTAssertEqual(
            Observable("hello"),
            Observable("hello")
        )

    }

}
