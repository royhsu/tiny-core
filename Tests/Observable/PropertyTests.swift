//
//  PropertyTests.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 2019/1/18.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - PropertyTests

import XCTest

@testable import TinyCore

final class PropertyTests: XCTestCase {

    private let expectionTimeout = 5.0

    private var observations: [Observation] = []

    func testDefault() {

        let property = Property<String>()

        XCTAssertNil(property.value)

    }

    func testObserveInitialValue() {

        let valueInitialized = expectation(description: "Observe the initial value.")

        let property = Property<String>()

        observations = [
            property.observe { change in

                switch change {

                case let .initial(newValue):

                    defer { valueInitialized.fulfill() }

                    XCTAssertEqual(
                        newValue,
                        "initial value"
                    )

                case .changed: XCTFail("Must be the initial value.")

                }

            }
        ]

        property.mutateValue { $0 = "initial value" }

        XCTAssertEqual(
            property.value,
            "initial value"
        )

        waitForExpectations(timeout: expectionTimeout)

    }

    func testObserveNewValue() {

        let valueChanged = expectation(description: "Observe the changed value.")

        let property = Property(value: "old value")

        observations = [
            property.observe { change in

                switch change {

                case .initial: XCTFail("Must be the changed value.")

                case let .changed(
                    oldValue,
                    newValue
                ):

                    defer { valueChanged.fulfill() }

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
        ]

        property.mutateValue { $0 = "new value" }

        waitForExpectations(timeout: expectionTimeout)

    }

    func testObserveOnSpecificQueue() {

        let observedOnQueue = expectation(description: "Observe changes on the specific queue.")

        let dynamicType = String(
            describing: type(of: self)
        )

        let queue = DispatchQueue(label: "\(dynamicType).SerialQueue.\(#function)")

        let property = Property<Int>()

        observations = [
            property.observe(on: queue) { _ in

                defer { observedOnQueue.fulfill() }

                dispatchPrecondition(
                    condition: .onQueue(queue)
                )

                XCTSuccess()

            }
        ]

        property.mutateValue { $0 = 1 }

        waitForExpectations(timeout: expectionTimeout)

    }

    func testBindToDestination() {

        let valueChanged = expectation(description: "Observe value changes for the bond view.")

        let view = TextView<String>(text: "unbound")

        let property = Property<String>()

        observations = [
            property.bind(
                on: .main,
                transform: { $0 ?? "bound" },
                to: (view, \.text)
            ),
            property.observe(on: .main) { _ in

                defer { valueChanged.fulfill() }

                XCTAssertEqual(
                    view.text,
                    "new value"
                )

            }
        ]

        XCTAssertEqual(
            view.text,
            "bound"
        )

        property.mutateValue { $0 = "new value" }

        waitForExpectations(timeout: expectionTimeout)

    }

    func testBindToDestinationWithOptionalValueKeyPath() {

        let valueChanged = expectation(description: "Observe value changes for the bond view.")

        let view = TextView<String?>(text: "old value")

        let property = Property<String>()

        observations = [
            property.bind(
                on: .main,
                transform: { $0?.uppercased() },
                to: (view, \.text)
            ),
            property.observe(on: .main) { _ in

                defer { valueChanged.fulfill() }

                XCTAssertEqual(
                    view.text,
                    "NEW VALUE"
                )

            }
        ]

        XCTAssertNil(view.text)

        property.mutateValue { $0 = "new value" }

        waitForExpectations(timeout: expectionTimeout)

    }

    func testEquatable() {

        XCTAssertEqual(
            Property(value: 1),
            Property(value: 1)
        )

        XCTAssertNotEqual(
            Property(value: 0),
            Property(value: 1)
        )

    }

    func testDecodable() throws {

        let decoder = JSONDecoder()

        let data = try JSONSerialization.data(withJSONObject: [ 1, 2 ])

        let decodedProperties = try decoder.decode(
            [Property<Int>].self,
            from: data
        )

        XCTAssertEqual(
            decodedProperties,
            [
                Property(value: 1),
                Property(value: 2)
            ]
        )

    }

    func testEncodable() throws {

        let encoder = JSONEncoder()

        XCTAssertEqual(
            try encoder.encode(
                [
                    Property(value: 1),
                    Property(value: 2)
                ]
            ),
            try JSONSerialization.data(withJSONObject: [ 1, 2 ])
        )

    }

}

// MARK: - TextView

fileprivate final class TextView<Text> {

    var text: Text

    init(text: Text) { self.text = text }

}
