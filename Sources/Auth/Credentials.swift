//
//  Credentials.swift
//  TinyCore
//
//  Created by Roy Hsu on 20/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - Credentials

// Todo: (version: 0.4.0, priority: .high)
// 1. Replace protocol with enum.

public protocol Credentials {

    // MARK: Property

    var grantType: GrantType { get }

}
