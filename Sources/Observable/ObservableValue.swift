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

// TODO: the current implementation will cause a problem that the child won't get notified while the parent change.
// Can't find the way to solve this issue.
public final class AnyObservable<Value>: ObservableProtocol {
    
    private let _observable: Observable<Value>
    
    private let _subscriptions: [ObservableSubscription]
    
    public init<O: ObservableProtocol>(_ base: O) where O.Value == Value {
        
        let observable = Observable<Value>()
        
        observable.value = base.value
        
        let subscription = observable.subscribe { event in

            base.value = event.newValue

        }
        
        let reversedSubscription = base.subscribe { event in
            
            observable.update(value: event.newValue)
            
        }
        
        self._observable = observable
        
        self._subscriptions = [
            subscription,
            reversedSubscription
        ]
        
    }
    
    public var value: Value? {
        
        get { return _observable.value }
        
        set { _observable.value = newValue }
        
    }
    
    public func subscribe(
        with subscriber: @escaping (ObservableEvent<Value>) -> Void
    )
    -> ObservableSubscription { return _observable.subscribe(with: subscriber) }
    
}

// MARK: - Observable

public final class Observable<Value>: ObservableProtocol {

    private typealias Event = ObservableEvent<Value>
    
    private typealias Subscriber = (Event) -> Void
    
    private final class Subscription<Value>: ObservableSubscription {
        
        internal final let subscriber: Subscriber
        
        internal init(subscriber: @escaping Subscriber) { self.subscriber = subscriber }
        
    }
    
    /// Indicating whether the value is set up firstly, and emitting the initial event to subscribers.
    private final var _isInitialValue: Bool = true
    
    public final var value: Value? {

        didSet {
            
            if _isSubscriptionsSkippable {
                
                _isSubscriptionsSkippable = false
                
                return
                
            }
            
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
    
    internal final var _isSubscriptionsSkippable = false
    
    internal func update(value: Value?) {
        
        _isSubscriptionsSkippable = true
        
        self.value = value
        
    }

}
