//
//  ObservableProtocol.swift
//  TinyCore
//
//  Created by Roy Hsu on 2018/9/11.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - ObservableProtocol

public protocol ObservableProtocol: AnyObject {
    
    associatedtype Value: Equatable
    
    typealias Event = ObservableEvent<Value>
    
    typealias Subscriber = (Event) -> Void
    
    var value: Value? { get set }
    
    func setValue(
        _ value: Value?,
        options: ObservableValueOptions?
    )
    
    func subscribe(
        with subscriber: @escaping Subscriber
    )
    -> ObservableSubscription
    
}

public extension ObservableProtocol {
    
    public func setValue(_ value: Value?) { self.value = value }
    
}
