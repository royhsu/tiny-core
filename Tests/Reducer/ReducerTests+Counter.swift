//
//  ReducerTests+Counter.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 2019/3/14.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - Counter

extension ReducerTests {
    
    struct Counter {
        
        var currentNumber: Int
        
        init(initialNumber: Int = 0) { self.currentNumber = initialNumber }
        
    }
    
}

// MARK: - Equatable

extension ReducerTests.Counter: Equatable {
    
    static func ==(
        lhs: ReducerTests.Counter,
        rhs: ReducerTests.Counter
    )
    -> Bool { return lhs.currentNumber == rhs.currentNumber }
    
}
