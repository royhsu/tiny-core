//
//  UserResource.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 19/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - User

import TinyCore

internal protocol UserResource {
    
    func readUser(
        id: UserID,
        completion: @escaping (_ result: Result<User>) -> Void
    )

}
