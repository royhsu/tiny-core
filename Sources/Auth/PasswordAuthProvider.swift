//
//  PasswordAuthProvider.swift
//  TinyCore
//
//  Created by Roy Hsu on 20/10/2017.
//  Copyright © 2017 TinyWorld. All rights reserved.
//

// MARK: - PasswordAuthProvider

public protocol PasswordAuthProvider: AuthProvider {

    func authenticate(
        credentials: PasswordCredentials,
        completion: @escaping (_ result: Result<Auth>) -> Void
    )

}
