//
//  CombinedReducersTests+Counter.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 2019/3/14.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - Counter

extension CombinedReducersTests {

    struct Counter: Equatable {

        var currentNumber: Int

        init(initialNumber: Int = 0) { self.currentNumber = initialNumber }

        // MARK: - Equatable

        static func == (lhs: Counter, rhs: Counter) -> Bool {

            return lhs.currentNumber == rhs.currentNumber

        }

    }

}
