//
//  URLRequest+HTTPHeader.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/1/26.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - HTTPHeader

extension URLRequest {
    
    public mutating func setHTTPHeaders(
        _ headers: [HTTPHeader: String]
    ) {
        
        for header in headers {
            
            setValue(
                header.key.rawValue,
                forHTTPHeaderField: header.value
            )
            
        }
        
    }
    
}
