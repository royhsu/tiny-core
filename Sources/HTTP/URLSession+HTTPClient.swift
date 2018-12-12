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
        decoder: DataDecoder,
        completion: @escaping (Result<T>) -> Void
    ) {

        let task = dataTask(with: request) { data, _, error in

            if let error = error {

                completion(
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

                completion(
                    .success(value)
                )

            }
            catch {

                completion(
                    .failure(error)
                )

            }

        }

        task.resume()

    }

}
