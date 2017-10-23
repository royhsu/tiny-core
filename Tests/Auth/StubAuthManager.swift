//
//  StubAuthManager.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 21/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - StubAuthManager

import TinyCore

internal final class StubAuthManager: AuthDelegate {

    // MARK: Property

    internal var grantedAuth: Auth?

    internal let providerType: AuthProvider.Type

    // MARK: Init

    internal init(
        stubAuth: Auth? = nil,
        providerType: AuthProvider.Type
    ) {

        self.grantedAuth = stubAuth

        self.providerType = providerType

    }

}
