//
//  APIServiceTests.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 19/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

class URLHTTPClient {
    
    let session: URLSession
    
    public init(session: URLSession? = nil) { self.session = session ?? .shared }

    func get<D: Decodable>(
        _ type: D.Type,
        in context: Context? = .background,
        with request: URLRequest,
        decoder: ModelDecoder
    )
    -> Future {
    
        return Promise<D>(in: context) { fulfill, reject, _ in
            
            let dataTask = self.session.dataTask(
                with: request,
                completionHandler: { data, response, error in
                    
                    if let error = error {
                        
                        reject(error)
                        
                        return
                        
                    }
                    
                    let data = data ?? Data()
                    
                    do {
                    
                        let object = try decoder.decode(
                            type,
                            from: data
                        )
                        
                        fulfill(object)
                        
                    }
                    catch { reject(error) }
                    
                }
            )
            
            dataTask.resume()
            
        }

    }

}

// MARK: - APIServiceTests

import XCTest

@testable import TinyCore

internal final class APIServiceTests: XCTestCase {

    // MARK: User

    internal final func testReadUserById() {

        let client: HTTPClient = UserHTTPClient()
        
        let url = URL(string: "http://www.apple.com")!
        
        let request = URLRequest(url: url)
        
        let promise = expectation(description: "")
        
        client
            .request(request)
            .then { (user: User) -> Void in
                
                promise.fulfill()
                
                print(user)
                
            }
            .catch { error in
            
                promise.fulfill()
                
                print("\(error)")
                
            }
        
        wait(
            for: [ promise ],
            timeout: 10.0
        )
        
//        let promise = expectation(description: "Read user by the given id.")
//
//        // swiftlint:disable nesting
//        struct Data {
//
//            let user: User
//
//        }
//        // swiftlint:enable nesting
//
//        let data = Data(
//            user: User(
//                id: UserID(rawValue: "1"),
//                name: "Roy Hsu"
//            )
//        )
//
//        do {
//
//            let json = try JSONEncoder().encode(data.user)
//
//            let service: UserAPIService = APIService(
//                client: StubHTTPClient(data: json)
//            )
//
//            service.readUser(id: data.user.id.rawValue) { result in
//
//                promise.fulfill()
//
//                switch result {
//
//                case .success(let user):
//
//                    XCTAssertEqual(
//                        user,
//                        data.user
//                    )
//
//                case .failure(let error):
//
//                    XCTFail("\(error)")
//
//                }
//
//            }
//
//            wait(
//                for: [ promise ],
//                timeout: 10.0
//            )
//
//        }
//        catch { XCTFail("\(error)") }

    }

}
