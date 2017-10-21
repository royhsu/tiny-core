//
//  HTTPError.swift
//  TinyCore
//
//  Created by Roy Hsu on 21/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

public enum HTTPError: Error {
    
    // MARK: Case
    
    case unauthorized
    
}

// MARK: - HTTP

public extension HTTPError {
    
    public var statusCode: Int {
        
        switch self {
            
        case .unauthorized:
            
            return 401
            
        }
        
    }
    
}

