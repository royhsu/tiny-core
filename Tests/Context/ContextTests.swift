//
//  ContextTests.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 2019/2/17.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - ContextTests

import XCTest

@testable import TinyCore

final class ContextTests: XCTestCase {

    func testMakeInstancesWithRegisteredIdentifiers() {

        enum ProductProperties: Hashable { case price }

        var context = Context<ProductProperties>()

        context.register({ 5.0 },
            for: .price
        )

        XCTAssertEqual(
            try context.make(
                Double.self,
                for: .price
            ),
            5.0
        )

    }

    func testMakeInstancesWithUnregisteredIdentifiers() {

        enum ProductProperties: Hashable { case title }

        let context = Context<ProductProperties>()

        XCTAssertThrowsError(
            try context.make(
                String.self,
                for: .title
            )
        ) { error in

            guard case ContextError<ProductProperties>.unregistered(identifier: .title) = error else {

                XCTFail("Unexpected error type. \(error)")

                return

            }

            XCTSuccess()

        }

    }

    func testMakeInstancesWithRegisteredIdentifiersButSpecifiedWrongType() {

        enum ProductProperties: Hashable { case title }

        var context = Context<ProductProperties>()

        context.register(
            "Chocolate",
            for: .title
        )

        XCTAssertThrowsError(
            try context.make(
                Int.self,
                for: .title
            )
        ) { error in

            guard let contextError = error as? ContextError<ProductProperties> else {

                XCTFail("Unexpected error type. \(error)")

                return

            }

            switch contextError {

            case let .typeMismatch(identifier, expectedType, autualType):

                XCTAssertEqual(
                    identifier,
                    .title
                )

                XCTAssert(expectedType is Int.Type)

                XCTAssert(autualType is String.Type)

            default: XCTFail("Unexpected error type. \(error)")

            }

        }

    }

    func testRegisterWithInitializale() {

        enum MessageProperties: Hashable { case user }

        struct User: Initializable, Equatable {

            let identifier = 1

        }

        var context = Context<MessageProperties>()

        context.register(
            User.self,
            for: .user
        )

        XCTAssertEqual(
            try context.make(
                User.self,
                for: .user
            ),
            User()
        )

    }

    func testMakeInstancesWithTypeInference() {

        enum ProductProperties: Hashable { case title }

        var context = Context<ProductProperties>()

        context.register(
            "Chocolate",
            for: .title
        )

        XCTAssertEqual(
            try context.make(for: .title),
            "Chocolate"
        )

    }

}
