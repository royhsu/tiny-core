//
//  AnyAuthService.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/3/15.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - AnyAuthService

public struct AnyAuthService<Credentials, Auth> {

    private let _authorize: (
        _ credentials: Credentials,
        _ completion: @escaping (Result<Auth, Error>) -> Void
    )
    -> ServiceTask

    public init<S>(_ service: S)
    where
        S: AuthService,
        S.Credentials == Credentials,
        S.Auth == Auth { self._authorize = service.authorize }

}

// MARK: - AuthService

extension AnyAuthService: AuthService {

    @discardableResult
    public func authorize(
        with credentials: Credentials,
        completion: @escaping (Result<Auth, Error>) -> Void
    )
    -> ServiceTask { return _authorize(credentials, completion) }

}
