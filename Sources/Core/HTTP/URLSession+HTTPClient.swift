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
    public final func request(
        _ request: URLRequestRepresentable,
        completion: @escaping (Result< HTTPResponse<Data?> >) -> Void
    )
    throws -> ServiceTask {

        let request = try request.urlRequest()

        let task = dataTask(with: request) { data, urlResponse, error in

            if let error = error {

                completion(
                    .failure(error)
                )

                return

            }

            guard let urlResponse = urlResponse else {

                completion(
                    .failure(HTTPError.noResponse)
                )

                return

            }

            let response = HTTPResponse(
                body: data,
                urlResponse: urlResponse
            )

            completion(
                .success(response)
            )

        }

        task.resume()

        return task

    }

}
