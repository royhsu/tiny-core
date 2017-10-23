//
//  AuthProvider.swift
//  TinyCore
//
//  Created by Roy Hsu on 20/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - AuthProvider

public protocol AuthProvider {
    
    func authorize(
        credentials: Credentials,
        completion: @escaping (Result<Auth>) -> Void
    )
    
}
