//
//  Binding.swift
//  TinyCore
//
//  Created by Roy Hsu on 2018/12/12.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - Binding

internal protocol Binding {

    associatedtype Value

    var target: AnyObject? { get }

    func update(with value: Value?)

}
