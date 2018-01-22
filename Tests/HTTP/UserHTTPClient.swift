//
//  UserHTTPClient.swift
//  TinyCore
//
//  Created by Roy Hsu on 22/01/2018.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

import TinyCore

internal final class UserHTTPClient: HTTPClient {
    
    func request(_ request: URLRequest, completion: @escaping (Result<Data>) -> Void) {
        fatalError()
    }
    
    public final func request(_ request: URLRequest) -> Future {
        
        return Promise<User> { fulfill, reject, _ in
            
            let user = User(
                id: UserID(rawValue: "1"),
                name: "Roy Hsu"
            )
            
            fulfill(user)
            
        }
        
    }
    
}

//func test() {
//
//    let client: HTTPClient = UserHTTPClient()
//
//    let future: Future<User> = client.request(
//        URLRequest(url: URL(string: "http://www.apple.com")!)
//    )
//
//}

