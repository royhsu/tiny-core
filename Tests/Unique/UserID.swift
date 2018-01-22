//
//  UserID.swift
//  TinyCore
//
//  Created by Roy Hsu on 04/08/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - UserID

import TinyCore

internal struct UserID: ID, Codable {

    internal let rawValue: String

}

extension UserID: Equatable { }
