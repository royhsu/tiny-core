//
//  StubRouter.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 19/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - StubRouter

import TinyCore
import Foundation

internal enum StubRouter: Router {

    // MARK: Case

    case readUser(id: UserID)

    // MARK: Router

    internal func makeURLRequest() throws -> URLRequest {

        switch self {

        case .readUser(let id):

            let url = URL(string: "http://api.foo.com/users/\(id.rawValue)")!

            return URLRequest(url: url)

        }

    }

}
