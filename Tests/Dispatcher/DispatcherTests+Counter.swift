//
//  DispatcherTests+Counter.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/3/14.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - ItemCounter

import TinyCore

extension DispatcherTests {

    class NumberCounter: DispatcherBatchScheduler {

        private let targetCount: Int

        private(set) var currentCount = 0

        init(targetCount: Int) { self.targetCount = targetCount }

        func increment() { currentCount += 1 }

        func shouldBatch(for numbers: [Int]) -> Bool {

            return numbers.count == targetCount

        }

    }

}
