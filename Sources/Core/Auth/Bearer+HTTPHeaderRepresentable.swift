//
//  Bearer+HTTPHeaderRepresentable.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/3/16.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - HTTPHeaderRepresentable

extension Bearer: HTTPHeaderRepresentable {

    public func httpHeader() throws -> (field: HTTPHeader, value: String) {

        return (
            .authorization,
            "Bearer \(token)"
        )

    }

}
