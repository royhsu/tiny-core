//
//  ObservedChangeProtocol.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/2/22.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - ObservedChangeProtocol

public protocol ObservedChangeProtocol {

    associatedtype Value
    
    var currentValue: Value? { get }

}
