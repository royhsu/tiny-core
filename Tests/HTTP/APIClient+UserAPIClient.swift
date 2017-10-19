//
//  APIClient+UserAPIClient.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 19/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - UserAPIClient

import TinyCore

extension APIClient: UserAPIClient {

    internal func readUser(
        id: UserID,
        completion: @escaping (_ result: HTTPResult<User>) -> Void) {

        let endpoint = APIRouter.readUser(id: id)

        httpClient.request(
            endpoint,
            for: User.self,
            completion: completion
        )

    }

}
