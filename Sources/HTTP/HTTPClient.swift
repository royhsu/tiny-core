//
//  HTTPClient.swift
//  TinyCore
//
//  Created by Roy Hsu on 19/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - HTTPClient

public protocol HTTPClient {

    @discardableResult
    func request<T: Decodable>(
        _ request: URLRequest,
        decoder: HTTPBodyDecoder,
        completion: @escaping (Result<(body: T, response: URLResponse)>) -> Void
    )
    -> URLSessionDataTask

}
