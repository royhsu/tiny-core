//
//  URLRequest+URLRequestRepresentable.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/1/26.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - URLRequestRepresentable

extension URLRequest: URLRequestRepresentable {

    public func urlRequest() throws -> URLRequest { return self }

}
