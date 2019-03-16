//
//  Basic+HTTPHeaderRepresentable.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/3/16.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - HTTPHeaderRepresentable

extension Basic: HTTPHeaderRepresentable {

    public func httpHeader() throws -> (field: HTTPHeader, value: String) {

        let data = Data("\(username):\(password)".utf8)

        let credentials = data.base64EncodedString()

        return (
            .authorization,
            "Basic \(credentials)"
        )

    }

}
