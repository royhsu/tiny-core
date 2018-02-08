//
//  FutureTests.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 08/02/2018.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - FutureTests

import XCTest

@testable import TinyCore

internal final class FutureTests: XCTestCase {

    internal final func testThen() {

        let promise = expectation(description: "Then should be executed.")

        let value = 10

        let future = Future(
            Promise(resolved: value)
        )

        future
            .then(in: .main) { result -> Void in

                XCTAssertEqual(
                    result,
                    value
                )

            }
            .catch(in: .main) { error in

                XCTFail("\(error)")

            }
            .always(in: .main) { promise.fulfill() }

        wait(
            for: [ promise ],
            timeout: 10.0
        )

    }

    internal final func testCatch() {

        let promise = expectation(description: "Catch should be executed.")

        let future = Future<Void>(
            Promise(rejected: FutureError.notExists)
        )

        future
            .then(in: .main) { _ -> Void in

                XCTFail("Should never be executed.")

            }
            .catch(in: .main) { error in

                XCTAssertEqual(
                    error as? FutureError,
                    .notExists
                )

            }
            .always(in: .main) { promise.fulfill() }

        wait(
            for: [ promise ],
            timeout: 10.0
        )

    }

}
