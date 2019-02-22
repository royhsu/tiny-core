//
//  HTTPResponse.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/1/26.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - HTTPResponse

public struct HTTPResponse<Body> {

    public var body: Body

    public var urlResponse: URLResponse

    public init(
        body: Body,
        urlResponse: URLResponse
    ) {

        self.body = body

        self.urlResponse = urlResponse

    }

}
