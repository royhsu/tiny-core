//
//  DispatcherBatchScheduler.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/2/22.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - DispatcherBatchScheduler

public protocol DispatcherBatchScheduler {

    func scheduleTask(
        _ task: @escaping (DispatcherBatchScheduler) -> Void
    )

}
