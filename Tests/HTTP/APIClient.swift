//
//  APIClient.swift
//  TinyCoreTests
//
//  Created by Roy Hsu on 19/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - APIClient

import TinyCore

public struct APIClient<HC: HTTPClient>
where HC.Value == Data {

    // MARK: Property

    public let httpClient: HC

}