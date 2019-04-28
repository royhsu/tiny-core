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
    func request(
        _ request: URLRequestRepresentable,
        completion: @escaping (Result<HTTPResponse<Data?>, Error>) -> Void
    )
    -> ServiceTask

}
