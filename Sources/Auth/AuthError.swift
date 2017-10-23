//
//  AuthError.swift
//  TinyCore
//
//  Created by Roy Hsu on 23/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - AuthError

public enum AuthError: Error {
    
    // MARK: Case
    
    case invalidCredentialsType(
        Credentials.Type,
        expectedType: Credentials.Type
    )
    
}
