//
//  CombinedReducersTests+Counter.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 2019/3/14.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - Counter

extension CombinedReducersTests {

    struct Counter {

        var currentNumber: Int

        init(initialNumber: Int = 0) { self.currentNumber = initialNumber }

    }

}

// MARK: - Equatable

extension CombinedReducersTests.Counter: Equatable {

    static func ==(
        lhs: CombinedReducersTests.Counter,
        rhs: CombinedReducersTests.Counter
    )
    -> Bool { return lhs.currentNumber == rhs.currentNumber }

}
