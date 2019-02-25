//
//  HTTPRequest+URLRequestRepresentable.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/1/26.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - URLRequestRepresentable

extension HTTPRequest: URLRequestRepresentable {

    public func urlRequest() throws -> URLRequest {

        var request = URLRequest(url: url)

        request.httpMethod = method.rawValue

        var headers = self.headers

        if let body = body {

            request.httpBody = try bodyEncoder.encode(body)

            let mime: MIMEType

            switch bodyEncoder {

            case is JSONEncoder: mime = .json

            default: fatalError("Unsupported HTTP Body Encoder.")

            }

            let header = try mime.httpHeader()

            headers[header.field] = header.value

        }

        request.setHTTPHeaders(headers)

        return request

    }

}
