//
//  URLSession+HTTPClient.swift
//  TinyCore
//
//  Created by Roy Hsu on 23/01/2018.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - HTTPClient

import Hydra

extension URLSession: HTTPClient {

    public final func data(
        in context: Context,
        with request: URLRequest
    )
    -> Promise<HTTPResult> {

        return Promise(in: context) { fulfill, reject, _ in

            let task = self.dataTask(
                with: request,
                completionHandler: { data, response, error in

                    if let error = error {

                        reject(error)

                        return

                    }

                    let data = data ?? Data()

                    let result = HTTPResult(
                        response: response!,
                        data: data
                    )

                    fulfill(result)

                }
            )

            task.resume()

        }

    }

}
