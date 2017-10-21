//
//  HTTPResponse+HTTPError.swift
//  TinyCore
//
//  Created by Roy Hsu on 21/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - HTTPError

public extension HTTPResponse {
    
    public static func unauthorized(with request: URLRequest) -> HTTPResponse {
        
        let error = HTTPError.unauthorized
        
        guard
            let url = request.url
        else { fatalError("The request must contain an url.") }
        
        guard
            let response = HTTPURLResponse(
                url: url,
                statusCode: error.statusCode,
                httpVersion: "HTTP/1.1",
                headerFields: nil
            )
        else { fatalError("Invalid HTTPURLResponse.") }
        
        return HTTPResponse(
            request: request,
            response: response,
            result: .failure(error)
        )
        
    }
    
}
