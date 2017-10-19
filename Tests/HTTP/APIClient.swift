//
//  APIClient.swift
//  TinyCoreTests
//
//  Created by 許郁棋 on 19/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - APIClient

import TinyCore

public struct APIClient<HC: HTTPClient>
where HC.Value: JSON {
    
    // MARK: Property
    
    public let httpClient: HC
    
}
