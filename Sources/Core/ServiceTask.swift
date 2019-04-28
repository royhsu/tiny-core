//
//  ServiceTask.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/1/21.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - ServiceTask

public protocol ServiceTask {

    func cancel()

}

// MARK: - Default Implementation

extension ServiceTask {

    public func cancel() { }

}
