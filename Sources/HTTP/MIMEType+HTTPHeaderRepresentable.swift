//
//  MIMEType+HTTPHeaderRepresentable.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/1/29.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - HTTPHeaderRepresentable

extension MIMEType: HTTPHeaderRepresentable {
    
    public func httpHeader() throws -> (field: HTTPHeader, value: String) { return (.contentType, rawValue) }
    
}
