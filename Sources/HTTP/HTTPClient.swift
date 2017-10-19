//
//  HTTPClient.swift
//  TinyCore
//
//  Created by Roy Hsu on 19/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - HTTPClient

import Foundation

public protocol HTTPClient {

    // MARK: Request

    func request(
        _ request: URLRequest,
        completion: @escaping (_ result: Result<Data>) -> Void
    )

}
