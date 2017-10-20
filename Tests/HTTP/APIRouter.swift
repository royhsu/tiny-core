//
//  APIRouter.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 19/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - APIRouter

import TinyCore

internal enum APIRouter: Router {

    // MARK: Case

    case readUser(
        id: UserID,
        auth: Auth
    )

    // MARK: Router

    internal func makeURLRequest() throws -> URLRequest {

        switch self {

        case .readUser(let id, let auth):
            
            let url = URL(string: "http://api.foo.com/users/\(id.rawValue)")!
            
            var request = URLRequest(url: url)
            
            switch auth.credential {
                
            case .accessToken(let accessToken):
                
                request.setValue(
                    "Bearer \(accessToken.rawValue)",
                    forHTTPHeaderField: "Authorization"
                )
                
            }
            
            return request
            
        }

    }

}
