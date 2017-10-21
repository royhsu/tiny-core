//
//  StubAuthManager.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 21/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - StubAuthManager

import TinyCore

internal struct StubAuthManager: AuthDelegate {
    
    // MARK: Property
    
    internal let auth: Auth?
    
    // MARK: Init
    
    internal init(auth: Auth?) {
        
        self.auth = auth
        
    }
    
    // MARK: AuthDelegate
    
    internal func authorize(completion: (Result<Auth>) -> Void) {
        
        guard
            let auth = auth
        else {
            
            completion(
                .failure(AuthError.notAuthorized)
            )
            
            return
                
        }
        
        completion(
            .success(auth)
        )
        
    }
    
}
