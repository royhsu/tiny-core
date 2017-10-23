//
//  UserManager.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 23/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - UserManager

import TinyCore

internal final class UserManager {
    
    // MARK: - AuthDelegate
    
    private final let authDelegate: AuthDelegate
    
    private final let service: HTTPService
    
    // MARK: Init
    
    internal init(
        authDelegate: AuthDelegate,
        service: HTTPService
    ) {
        
        self.authDelegate = authDelegate
        
        self.service = service
        
    }
    
}

// MARK: - UserResource

extension UserManager: UserResource {
    
    internal func readUser(
        id: UserID,
        completion: @escaping (Result<User>) -> Void
    ) {
        
        let endpoint = StubRouter.readUser(id: id)
        
        service.request(
            endpoint,
            middlewares: [ AuthHTTPMiddleware(authDelegate: authDelegate) ],
            decoder: JSONDecoder(),
            completion: completion
        )
        
    }
    
}
