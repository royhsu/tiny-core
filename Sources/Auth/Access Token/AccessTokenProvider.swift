//
//  AccessTokenProvider.swift
//  TinyCore
//
//  Created by Roy Hsu on 23/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - AccessTokenProvider

public protocol AccessTokenProvider: AuthProvider {
    
    static func authorize(
        credentials: AccessTokenCredentials,
        completion: @escaping (_ result: Result<Auth>) -> Void
    )
    
}

// MARK: - AuthProvider (Default Implementation)

public extension AccessTokenProvider {
    
    public static func requestAuth(
        credentials: Credentials,
        completion: @escaping (Result<Auth>) -> Void
    ) {
        
        guard
            let accessTokenCredentials = credentials as? AccessTokenCredentials
        else {
            
            let credentialsType = type(of: credentials)
            
            let error = AuthError.invalidCredentialsType(
                credentialsType.self,
                expectedType: AccessTokenCredentials.self
            )
            
            completion(
                .failure(error)
            )
            
            return
                
        }
        
        authorize(
            credentials: accessTokenCredentials,
            completion: completion
        )
        
    }
    
}
