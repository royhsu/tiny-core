//
//  HTTPClient+JSONInitializable.swift
//  TinyCore
//
//  Created by Roy Hsu on 19/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// Todo: (version: nil, priority: .high)
// 1. replace JSONInitialiable with Codeable.

// MARK: - JSONInitializable

public extension HTTPClient
where Value: JSON {

    public func request<Model: JSONInitializable>(
        _ router: Router,
        completion: @escaping (_ result: HTTPResult<Model>) -> Void
    ) {

        request(router) { result in

            switch result {

            case .success(let value):

                do {

                    let model = try Model(value)

                    completion(
                        .success(model)
                    )

                }
                catch {

                    completion(
                        .failure(error)
                    )

                }

            case .failure(let error):

                completion(
                    .failure(error)
                )

            }

        }

    }

}
