//
//  UserAPIClient.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 19/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - UserAPIClient

import TinyCore

internal protocol UserAPIClient {
    
    func readUser(
        id: String,
        completion: @escaping (_ result: HTTPResult<User>) -> Void
    )
    
}
