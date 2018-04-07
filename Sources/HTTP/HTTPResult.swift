//
//  HTTPResult.swift
//  TinyCore
//
//  Created by Roy Hsu on 08/02/2018.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - HTTPResult

public struct HTTPResult {

    public let response: URLResponse

    public let data: Data

    public init(
        response: URLResponse,
        data: Data
    ) {

        self.response = response

        self.data = data

    }

}
