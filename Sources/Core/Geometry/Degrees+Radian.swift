//
//  Degrees+Radian.swift
//  TinyCore
//
//  Created by Roy Hsu on 2018/4/5.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - Radian

public extension Degrees {

    public var radian: Radian {

        let value = rawValue / (180.0 * Double.pi)

        return Radian(rawValue: value)

    }

}
