//
//  AuthService.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/3/15.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - AuthService

public protocol AuthService {
    
    associatedtype Credentials
    
    associatedtype Auth
    
    @discardableResult
    func authorize(
        with credentials: Credentials,
        completion: @escaping (Result<Auth>) -> Void
    )
    throws -> ServiceTask
    
}
