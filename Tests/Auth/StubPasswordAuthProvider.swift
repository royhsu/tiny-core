//
//  StubPasswordAuthProvider.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 20/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - StubPasswordAuthProvider

import TinyCore

internal final class StubPasswordAuthProvider: PasswordAuthProvider {
    
    // MARK: Property
    
    internal final let result: Result<Auth>
    
    // MARK: Init
    
    internal init(result: Result<Auth>) {
        
        self.result = result
        
    }
    
    // MARK: PasswordAuthProvider
    
    func signIn(username: String, password: String, completion: @escaping (Result<Auth>) -> Void) {
        
        completion(result)
        
    }
    
}
