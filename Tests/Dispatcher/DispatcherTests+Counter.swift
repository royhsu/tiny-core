//
//  DispatcherTests+Counter.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/3/14.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - Counter

extension DispatcherTests {
    
    class Counter {
        
        private let limitNumber: Int
        
        private var currentNumber = 0
        
        private var completion: ( (Counter) -> Void )?
        
        init(limitNumber: Int) { self.limitNumber = limitNumber }
        
    }
    
}

extension DispatcherTests.Counter {
    
    func count() {
        
        if currentNumber > limitNumber { preconditionFailure("The counter has reached the number.") }
        
        currentNumber += 1
        
        guard currentNumber == limitNumber else { return }
        
        completion?(self)
        
    }
    
}

// MARK: - DispatcherBatchScheduler

import TinyCore

extension DispatcherTests.Counter: DispatcherBatchScheduler {
    
    func scheduleTask(_ task: @escaping (DispatcherBatchScheduler) -> Void) { completion = task }
    
}
