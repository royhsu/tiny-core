//
//  HTTPClient+Decodable.swift
//  TinyCore
//
//  Created by Roy Hsu on 19/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - Decodable

import Foundation

public extension HTTPClient
where Value == Data {

    public func request<Model: Decodable>(
        _ request: URLRequest,
        completion: @escaping (_ result: HTTPResult<Model>) -> Void
    ) {

        self.request(request) { result in

            switch result {

            case .success(let value):

                do {

                    let model = try JSONDecoder().decode(
                        Model.self,
                        from: value
                    )

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
