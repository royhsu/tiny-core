//
//  Locale+CustomLocalizedStringConvertible.swift
//  AlleyCore
//
//  Created by Roy Hsu on 2019/3/1.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - CustomLocalizedStringConvertible

extension Locale: CustomLocalizedStringConvertible {

    public var localizedDescription: String { return localizedString(forIdentifier: identifier)! }

}
