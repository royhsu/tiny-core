//
//  HTTPClient.swift
//  TinyCore
//
//  Created by Roy Hsu on 19/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - HTTPClient

public protocol HTTPClient: class {

    // MARK: Request

    func request(
        _ request: URLRequest,
        completion: @escaping (_ result: Result<Data>) -> Void
    )

}
