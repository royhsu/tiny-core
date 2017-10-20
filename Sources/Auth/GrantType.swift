//
//  GrantType.swift
//  TinyCore
//
//  Created by Roy Hsu on 20/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - GrantType

public enum GrantType: String {

    // MARK: Case

    case password = "password"

    // Todo: (version: nil, priority: .high)
    // 1. use uppercased raw value or not.
    case jwt = "jwt-bearer"

}
