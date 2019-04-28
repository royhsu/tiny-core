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

    private var observations: [Observation] = []

    func testDefault() {

        let property = Property<String>()

        XCTAssertNil(property.value)

    }

    func testModifyValue() {

        let property = Property(0)

        property.modify { $0 = 1 }

        XCTAssertEqual(property.value, 1)

    }

    func testObserveInitialValue() {

        let didObserveInitialValue = expectation(
            description: "Observe the initial change."
        )

        let property = Property<String>()

        observations = [
            property.observe { change in

                switch change {

                case let .initial(newValue):

                    defer { didObserveInitialValue.fulfill() }

                    XCTAssertEqual(newValue, "initial value")

                case .changed: XCTFail("Must be the initial value.")

                }

            }
        ]

        property.modify { $0 = "initial value" }

        waitForExpectations(timeout: 10.0)

    }

    func testObserveNewValue() {

        let didObserveNewValue = expectation(description: "Observe the changed value.")

        let property = Property("old value")

        observations = [
            property.observe { change in

                switch change {

                case .initial: XCTFail("Must be the changed value.")

                case let .changed(oldValue, newValue):

                    defer { didObserveNewValue.fulfill() }

                    XCTAssertEqual(oldValue, "old value")

                    XCTAssertEqual(newValue, "new value")

                }

            }
        ]

        property.modify { $0 = "new value" }

        waitForExpectations(timeout: 10.0)

    }

    func testObserveOnSpecificQueue() {

        let didObserveChangesOnQueue = expectation(description: "Observe changes on the specific queue.")

        let dynamicType = String(describing: type(of: self))

        let queue = DispatchQueue(label: "\(dynamicType).SerialQueue.\(#function)")

        let property = Property(0)

        observations = [
            property.observe(on: queue) { _ in

                defer { didObserveChangesOnQueue.fulfill() }

                dispatchPrecondition(
                    condition: .onQueue(queue)
                )

            }
        ]

        property.modify { $0 = 1 }

        waitForExpectations(timeout: 10.0)

    }

    func testBindToDestination() {

        let bondViewDidChangeValue = expectation(description: "Observe value changes for the bond view.")

        let view = TextView<String>(text: "unbound")

        let property = Property<String>()

        observations = [
            property.bind(
                on: .main,
                transform: { $0 ?? "bound" },
                to: (view, \.text)
            ),
            property.observe(on: .main) { _ in

                defer { bondViewDidChangeValue.fulfill() }

                XCTAssertEqual(
                    view.text,
                    "new value"
                )

            }
        ]

        XCTAssertEqual(view.text, "bound" )

        property.modify { $0 = "new value" }

        waitForExpectations(timeout: 10.0)

    }

    func testBindToDestinationWithOptionalValueKeyPath() {

        let bondViewDidChangeValue = expectation(description: "Observe value changes for the bond view.")

        let view = TextView<String?>(text: "old value")

        let property = Property<String>()

        observations = [
            property.bind(
                on: .main,
                transform: { $0?.uppercased() },
                to: (view, \.text)
            ),
            property.observe(on: .main) { _ in

                defer { bondViewDidChangeValue.fulfill() }

                XCTAssertEqual(view.text, "NEW VALUE")

            }
        ]

        XCTAssertNil(view.text)

        property.modify { $0 = "new value" }

        waitForExpectations(timeout: 10.0)

    }

    func testEquatable() {

        XCTAssertEqual(Property(0), Property(0))

        XCTAssertNotEqual(Property(0), Property(1))

    }

}

// MARK: - TextView

extension PropertyTests {

    final class TextView<Text> {

        var text: Text

        init(text: Text) { self.text = text }

    }

}
