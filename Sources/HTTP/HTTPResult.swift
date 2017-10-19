//
//  HTTPResult.swift
//  TinyCore
//
//  Created by Roy Hsu on 19/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - HTTPResult

public enum HTTPResult<Value> {

    // MARK: Case

    case success(Value)

    case failure(Error)

}