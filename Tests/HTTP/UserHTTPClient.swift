//
//  UserHTTPClient.swift
//  TinyCore
//
//  Created by Roy Hsu on 22/01/2018.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

import TinyCore

internal final class UserHTTPClient: HTTPClient {
    
    internal final func request(_ request: URLRequest) -> Future {
        
        return Promise<User>(in: .background) { fulfill, reject, _ in
            
            let user = User(
                id: UserID(rawValue: "1"),
                name: "Roy Hsu"
            )

            fulfill(user)
            
        }

    }
    
}
