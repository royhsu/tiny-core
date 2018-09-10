//
//  HTTPClient.swift
//  TinyCore
//
//  Created by Roy Hsu on 19/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - HTTPClient

public protocol HTTPClient {

    func request<T: Decodable>(
        _ request: URLRequest,
        decoder: Decoder,
        completionHandler: @escaping (Result<T>) -> Void
    )

}
