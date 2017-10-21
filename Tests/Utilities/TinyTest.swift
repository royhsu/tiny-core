//
//  TinyTest.swift
//  NextBookTests
//
//  Created by Roy Hsu on 05/08/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - TinyTest

import XCTest

// MARK: - TestError

public enum TestError: Error {

    // MARK: Case

    case unexpectedNil

}

public func performTest(
    file: StaticString = #file,
    line: UInt = #line,
    _ block: () throws -> Void
) {

    do { try block() }
    catch {

        XCTFail(
            "\(error)",
            file: file,
            line: line
        )

    }

}

@discardableResult
public func unwrap<T>(
    _ value: T?,
    file: StaticString = #file,
    line: UInt = #line
)
throws -> T {

    guard
        let value = value
    else {

        XCTFail("Unwrapped nil", file: file, line: line)

        throw TestError.unexpectedNil

    }

    return value

}
