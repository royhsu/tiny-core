//
//  URLSession+HTTPClient.swift
//  TinyCore
//
//  Created by Roy Hsu on 23/01/2018.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - HTTPClient

extension URLSession: HTTPClient {

    @discardableResult
    public final func request<T: Decodable>(
        _ request: URLRequest,
        decoder: HTTPBodyDecoder,
        completion: @escaping (Result<(body: T, response: URLResponse)>) -> Void
    )
    -> URLSessionDataTask {

        let task = dataTask(with: request) { data, response, error in

            if let error = error {

                completion(
                    .failure(error)
                )

                return

            }
            
            guard let response = response else {
                
                completion(
                    .failure(HTTPClientError.noResponse)
                )
                
                return
                
            }

            let data = data ?? Data()

            do {

                let body = try decoder.decode(
                    T.self,
                    from: data
                )

                let value = (body, response)
                
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
        
        return task

    }

}
