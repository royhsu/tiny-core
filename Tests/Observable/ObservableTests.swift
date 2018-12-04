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

    internal final var obveration: Observation?

    internal final func testInitialize() {

        let observable = Observable<String>()

        XCTAssert(observable.value == nil)

    }

    internal final func testSetInitialValue() {

        let promise = expectation(description: "Get notified about value changes.")

        let observable = Observable<String>()

        obveration = observable.observe { change in

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

        let observable = Observable<String>("old value")

        obveration = observable.observe { change in

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

    internal final func testTypeErasable() {

        let observable = Observable<String>()

        _ = AnyObservable(observable)

        XCTSuccess()

    }

}
