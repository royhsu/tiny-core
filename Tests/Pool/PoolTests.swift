//
//  PoolTests.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/2/18.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - PoolTests

import XCTest

@testable import TinyCore

final class PoolTests: XCTestCase {

    func testDefault() {

        let pool = Pool<Int, Cell> { _ in Cell() }

        XCTAssert(pool.activeObjectStorage.isEmpty)

        XCTAssert(pool.inactiveObjects.isEmpty)

    }

    func testDequeueSameElement() throws {

        let identifier = String(describing: Cell.self)

        let pool = Pool<String, Cell> { _ in Cell() }

        let cell1 = try pool.dequeue(for: identifier)

        let cell2 = try pool.dequeue(for: identifier)

        XCTAssert(cell1 === cell2)

    }

    func testRecycleObjects() throws {

        let identifier = String(describing: Cell.self)

        let pool = Pool<String, Cell> { _ in Cell() }

        let cell1 = try pool.dequeue(for: identifier)

        XCTAssertEqual(
            pool.activeObjectStorage,
            [ identifier: cell1 ]
        )

        pool.recycle()

        XCTAssert(pool.activeObjectStorage.isEmpty)

        XCTAssertEqual(
            pool.inactiveObjects,
            [ cell1 ]
        )

        let cell2 = try pool.dequeue(for: identifier)

        XCTAssertEqual(
            pool.activeObjectStorage,
            [ identifier: cell2 ]
        )

        XCTAssert(pool.inactiveObjects.isEmpty)

        XCTAssert(cell1 === cell2)

    }

}

// MARK: - Cell

private class Cell: Equatable {

    static func == (lhs: Cell, rhs: Cell) -> Bool { return lhs === rhs }

}
