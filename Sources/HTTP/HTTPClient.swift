//
//  HTTPClient.swift
//  TinyCore
//
//  Created by Roy Hsu on 19/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - HTTPClient

public protocol HTTPClient {
    
    func request(_ request: URLRequest) -> Future
    
}

public extension HTTPClient {
    
    public func request<D: Decodable>(
        _ request: URLRequest,
        in context: FutureContext? = nil,
        decoder: ModelDecoder,
        for type: D.Type
    )
    -> Future {
        
        return self
            .request(request)
            .then(in: context) { (data: Data) -> D in
                
                let object = try decoder.decode(
                    type,
                    from: data
                )
                
                return object
                
            }
        
    }
    
}
