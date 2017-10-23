//
//  BasicAuthProvider.swift
//  TinyCore
//
//  Created by Roy Hsu on 20/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - BasicAuthProvider

public protocol BasicAuthProvider: AuthProvider {

    func authenticate(
        credentials: BasicAuthCredentials,
        completion: @escaping (_ result: Result<Auth>) -> Void
    )

}

// MARK: - AuthProvider (Default Implementation)

public extension BasicAuthProvider {
    
    public func authorize(
        credentials: Credentials,
        completion: @escaping (Result<Auth>) -> Void
    ) {
        
        guard
            let basicAuthCredentials = credentials as? BasicAuthCredentials
        else {
            
            let credentialsType = type(of: credentials)
            
            let error = AuthError.invalidCredentialsType(
                credentialsType.self,
                expectedType: BasicAuthCredentials.self
            )
            
            completion(
                .failure(error)
            )
            
            return
            
        }
        
        authenticate(
            credentials: basicAuthCredentials,
            completion: completion
        )
        
    }
    
}
