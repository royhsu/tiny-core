//
//  APIService+UserAPIService.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 19/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - UserAPIService

import TinyCore

extension APIService: UserAPIService {

    internal func readUser(
        id: UserID,
        completion: @escaping (_ result: Result<User>) -> Void) {

        let endpoint = APIRouter.readUser(id: id)

        client.request(
            endpoint,
            decoder: JSONDecoder(),
            completion: completion
        )

    }

}
