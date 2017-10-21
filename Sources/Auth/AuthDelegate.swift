//
//  AuthDelegate.swift
//  TinyCore
//
//  Created by Roy Hsu on 21/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - AuthDelegate

public protocol AuthDelegate {

    var auth: Auth? { get }

    func authorize(
        completion: (_ result: Result<Auth>) -> Void
    )

}
