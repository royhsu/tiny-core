//
//  ObservableProtocol.swift
//  TinyCore
//
//  Created by Roy Hsu on 2018/9/11.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - ObservableProtocol

// TODO: should follow along with the design of KVO in Cocoa.
public protocol ObservableProtocol {
    
    associatedtype Value
    
    typealias Event = ObservableEvent<Value>
    
    typealias Subscriber = (Event) -> Void
    
    var value: Value? { get set }
    
    func setValue(
        _ value: Value?,
        options: ObservableValueOptions?
    )
    
    // TODO: rename to observe.
    func subscribe(with subscriber: @escaping Subscriber) -> ObservableSubscription
    
}

public extension ObservableProtocol {
    
    public mutating func setValue(_ value: Value?) { self.value = value }
    
}
