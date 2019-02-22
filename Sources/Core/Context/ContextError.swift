//
//  ContextError.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/2/17.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - ContextError

public enum ContextError<Identifier>: Error where Identifier: Hashable {

    case unregistered(identifier: Identifier)

    case typeMismatch(
        identifier: Identifier,
        expectedType: Any.Type,
        autualType: Any.Type
    )

}
