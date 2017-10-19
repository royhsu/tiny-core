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
        completion: @escaping (HTTPResult<User>) -> Void) {

        httpClient.request(
            StubRouter.readUser(id: id),
            completion: completion
        )

    }

}
