//
//  HTTPService+Router.swift
//  TinyCore
//
//  Created by Roy Hsu on 19/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - Router

public extension HTTPService {

    public func request<Model: Decodable>(
        _ router: HTTPRouter,
        middlewares: [HTTPMiddleware],
        decoder: ModelDecoder,
        completion: @escaping (_ result: Result<Model>) -> Void
    ) {

        do {

            let endpoint = try router.makeURLRequest()

            request(
                endpoint,
                middlewares: middlewares,
                decoder: decoder,
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
