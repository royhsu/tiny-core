//
//  StubAuth.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 20/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - StubAuth

import TinyCore

internal struct StubAuth: Auth {

    // MARK: Property

    internal let credentials: Credentials

    internal let provider: AuthProvider

}
