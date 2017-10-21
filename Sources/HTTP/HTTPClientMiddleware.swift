//
//  HTTPClientMiddleware.swift
//  TinyCore
//
//  Created by Roy Hsu on 20/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - HTTPClientMiddleware

public protocol HTTPClientMiddleware: class {

    func respond(
        to request: URLRequest,
        completion: @escaping (_ result: Result<Data>) -> Void
    ) -> (URLRequest, (Result<Data>) -> Void)

}
