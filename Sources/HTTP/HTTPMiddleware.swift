//
//  HTTPMiddleware.swift
//  TinyCore
//
//  Created by Roy Hsu on 20/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - HTTPMiddleware

public protocol HTTPMiddleware {

    func respond(
        to request: URLRequest,
        completion: @escaping (_ response: HTTPResponse) -> Void
    )
    -> (request: URLRequest, completion: (HTTPResponse) -> Void)

}
