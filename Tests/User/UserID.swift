//
//  UserID.swift
//  TinyCore
//
//  Created by Roy Hsu on 04/08/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - UserID

import Foundation

@testable import TinyCore

internal struct UserID: ID, Codable {

    // MARK: Property

    internal var rawValue: String
    
    // MARK: Init
    
    internal init(rawValue: String) {
        
        self.rawValue = rawValue
        
    }
    
    // MARK: Codable

    internal init(from coder: Decoder) throws {
        
        let container = try coder.singleValueContainer()
        
        self.rawValue = try container.decode(String.self)
        
    }
    
    internal func encode(to encoder: Encoder) throws {
        
        var container = encoder.singleValueContainer()
        
        try container.encode(rawValue)
        
    }

}
