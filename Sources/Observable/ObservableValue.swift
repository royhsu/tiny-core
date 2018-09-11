//
//  ObservableValue.swift
//  TinyCore
//
//  Created by Roy Hsu on 17/03/2018.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

public enum ObservableEvent<Value> {
    
    case initial(newValue: Value?)

    case changed(
        newValue: Value?,
        oldValue: Value?
    )
    
    public var newValue: Value? {
        
        switch self {
            
        case let .initial(newValue): return newValue
            
        case let .changed(newValue, _): return newValue
            
        }
        
    }
    
}

// MARK: - ObservableSubscription

public protocol ObservableSubscription { }

public protocol ObservableProtocol: AnyObject {
    
    associatedtype Value
    
    var value: Value? { get set }
    
    func subscribe(
        with subscriber: @escaping (ObservableEvent<Value>) -> Void
    )
    -> ObservableSubscription
    
}

// MARK: - Observable

public final class Observable<Value>: ObservableProtocol {

    private typealias Event = ObservableEvent<Value>
    
    private typealias Subscriber = (Event) -> Void
    
    private final class Subscription<Value>: ObservableSubscription {
        
        internal final let subscriber: Subscriber
        
        internal init(subscriber: @escaping Subscriber) { self.subscriber = subscriber }
        
    }
    
    private final var _isInitialValue = true
    
    public final var value: Value? {

        didSet {
    
            if _isInitialValue {
                
                _isInitialValue = false
                
                let initialValue = value
                
                // Clean up the dead objects.
                subscriptionObjects.removeAll { $0.reference == nil }
                
                subscriptionObjects.forEach { object in
                    
                    object.reference?.subscriber(
                        Event.initial(newValue: initialValue)
                    )
                    
                }
                
                return
                
            }
            
            let newValue = value

            // Clean up the dead objects.
            subscriptionObjects.removeAll { $0.reference == nil }
            
            subscriptionObjects.forEach { object in

                object.reference?.subscriber(
                    Event.changed(
                        newValue: newValue,
                        oldValue: oldValue
                    )
                )

            }

        }

    }
    
    public init() { }
    
    private final var subscriptionObjects: [WeakObject<Subscription<Value>>] = []

    public final func subscribe(
        with subscriber: @escaping (ObservableEvent<Value>) -> Void
    )
    -> ObservableSubscription {
        
        let subscription = Subscription<Value>(subscriber: subscriber)
        
        subscriptionObjects.append(
            WeakObject(subscription)
        )
        
        return subscription
        
    }

}
