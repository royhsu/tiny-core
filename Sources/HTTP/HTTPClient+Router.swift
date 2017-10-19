//
//  HTTPClient+Router.swift
//  TinyCore
//
//  Created by Roy Hsu on 19/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - Router

import Foundation

public extension HTTPClient
where Value == Data {

    public func request<Model: Decodable>(
        _ router: Router,
        for modelType: Model.Type,
        completion: @escaping (_ result: HTTPResult<Model>) -> Void
    ) {

        do {

            let endpoint = try router.makeURLRequest()
            
            request(
                endpoint,
                for: modelType,
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
