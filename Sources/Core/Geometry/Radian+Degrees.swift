//
//  Radian+Degrees.swift
//  TinyCore
//
//  Created by Roy Hsu on 2018/4/5.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - Radian

extension Radian {

    public var degrees: Degrees {

        let value = rawValue * (180.0 / Double.pi)

        return Degrees(rawValue: value)

    }

}
