//
//  HTTPClient.swift
//  TinyCore
//
//  Created by Roy Hsu on 19/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - HTTPClient

public protocol HTTPClient {

    func data(
        in context: FutureContext,
        with request: URLRequest
    )
    -> Future<HTTPResult>

}

// MARK: - Model

public extension HTTPClient {

    public func model<D: Decodable>(
        in context: FutureContext,
        _ type: D.Type,
        with request: URLRequest,
        decoder: ModelDecoder
    )
    -> Future<D> {

        return self.data(
            in: context,
            with: request
        )
        .then(in: context) { result in

            let object = try decoder.decode(
                type,
                from: result.data
            )

            return object

        }

    }

}
