//
//  HTTPClient+Router.swift
//  TinyCore
//
//  Created by Roy Hsu on 19/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - Router

import Foundation

public extension HTTPClient {

    public func request(
        _ router: Router,
        completion: @escaping (_ result: HTTPResult<Value>) -> Void
    ) {

        do {

            let endpoint = try router.makeURLRequest()

            request(
                endpoint,
                completion: completion
            )

        }
        catch {

            completion(
                .failure(error)
            )

        }

    }

}
