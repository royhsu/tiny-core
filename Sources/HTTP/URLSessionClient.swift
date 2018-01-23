//
//  URLSessionClient.swift
//  TinyCore
//
//  Created by Roy Hsu on 23/01/2018.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - URLSessionClient

public final class URLSessionClient {
    
    public final let session: URLSession
    
    public init(session: URLSession? = nil) { self.session = session ?? .shared }
    
}

// MARK: - HTTPClient

extension URLSessionClient: HTTPClient {
    
    public final func data(
        with request: URLRequest,
        in context: FutureContext
    )
    -> Future<Data> {
        
        let context = Context(context)
        
        let promise = Promise<Data>(in: context) { fulfill, reject, _ in
            
            let dataTask = self.session.dataTask(
                with: request,
                completionHandler: { data, response, error in
                    
                    if let error = error {
                        
                        reject(error)
                        
                        return
                        
                    }
                    
                    let data = data ?? Data()
                    
                    fulfill(data)
                    
                }
            )
            
            dataTask.resume()
            
        }
        
        return Future(promise)
        
    }
    
}
