//
//  HTTPService+Decodable.swift
//  TinyCore
//
//  Created by Roy Hsu on 19/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - Decodable

public extension HTTPService {

    public func request<Model: Decodable>(
        _ request: URLRequest,
        middlewares: [HTTPMiddleware],
        decoder: ModelDecoder,
        completion: @escaping (_ result: Result<Model>) -> Void
    ) {

        self.request(
            request,
            middlewares: middlewares,
            completion: { response in

                switch response.result {

                case .success(let value):

                    do {

                        let model = try decoder.decode(
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
        )

    }

}
