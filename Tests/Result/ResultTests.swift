//
//  ResultTests.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 2018/9/10.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - ResultTests

import XCTest

@testable import TinyCore

internal final class ResultTests: XCTestCase {

    internal final func testResolveSuccess() {

        let result = Result.success(5)

        do {

            let value = try result.get()

            XCTAssertEqual(
                value,
                5
            )

        }
        catch { XCTFail("Unexpected error: \(error)") }

    }

    internal final func testResolveFailure() {

        let result = Result<Int>.failure(HTTPError.notFound)

        XCTAssertThrowsError(
            try result.get()
        ) { error in

            if case HTTPError.notFound = error { XCTSuccess() }
            else { XCTFail("Unexpected error: \(error)") }

        }

    }

}
