//
//  URLSession+HTTPClient.swift
//  TinyCore
//
//  Created by Roy Hsu on 23/01/2018.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - HTTPClient

extension URLSession: HTTPClient {

    public final func request<T: Decodable>(
        _ request: URLRequest,
        decoder: Decoder,
        completionHandler: @escaping (Result<T>) -> Void
    ) {

        let task = dataTask(with: request) { data, _, error in

            if let error = error {

                completionHandler(
                    .failure(error)
                )

                return

            }

            let data = data ?? Data()

            do {

                let value = try decoder.decode(
                    T.self,
                    from: data
                )

                completionHandler(
                    .success(value)
                )

            }
            catch {

                completionHandler(
                    .failure(error)
                )

            }

        }

        task.resume()

    }

}
