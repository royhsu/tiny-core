//
//  Observable.swift
//  TinyCore
//
//  Created by Roy Hsu on 17/03/2018.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - Observable

public final class Observable<Value>: ObservableProtocol
//where Value: Equatable
{
    
    private final class Subscription: ObservableSubscription {
        
        internal final let subscriber: Subscriber
        
        internal init(subscriber: @escaping Subscriber) { self.subscriber = subscriber }
        
    }
    
    private final var subscriptions: [ObservableSubscription] = []
    
    private final var _isInitialValue = true
    
    private final var _value: Value?
    
    public final var value: Value? {
        
        get { return _value }
        
        set {
            
            let oldValue = value
            
            // TODO: This will prevent notifying if the observable nested inside a wrapper.
//            if oldValue == newValue { return }
            
            _value = newValue
            
            if _isInitialValue {
                
                _isInitialValue = false
                
                DispatchQueue.global(qos: .default).async {
                    
                    self.boardcaster.notifyAllSubscribers(
                        with: .initial(newValue: newValue)
                    )
                    
                }
                
            }
            else {
                
                DispatchQueue.global(qos: .default).async {
                
                    self.boardcaster.notifyAllSubscribers(
                        with: .changed(
                            newValue: newValue,
                            oldValue: oldValue
                        )
                    )
                }
                
            }
            
        }
        
    }
    
    public final func setValue(
        _ newValue: Value?,
        options: ObservableValueOptions = []
    ) {
        
        let oldValue = value

        // TODO: This will prevent notifying if the observable nested inside a wrapper.
//        if oldValue == newValue { return }

        _value = newValue

        if _isInitialValue {
            
            _isInitialValue = false
            
            if options.contains(.muteBroadcaster) { return }
            
            boardcaster.notifyAllSubscribers(
                with: .initial(newValue: newValue)
            )
            
            return
                
        }
            
        if options.contains(.muteBroadcaster) { return }
            
        boardcaster.notifyAllSubscribers(
            with: .changed(
                newValue: newValue,
                oldValue: oldValue
            )
        )
            
    }
    
    private final class Broadcaster {
        
        internal typealias Object = WeakObject<Subscription>
        
        private final var objects: [Object] = []
        
        internal final func addSubscriber(_ subscriber: @escaping Subscriber) -> ObservableSubscription {
            
            let subscription = Subscription(subscriber: subscriber)
            
            objects.append(
                WeakObject(subscription)
            )
            
            return subscription
            
        }
        
        internal final func notifyAllSubscribers(with event: Event) {
            
            // Clean up the dead objects.
            objects.removeAll { $0.reference == nil }
            
            objects.forEach { $0.reference?.subscriber(event) }
            
        }
        
    }
    
    private final let boardcaster = Broadcaster()

    public init() { }
    
    public final func subscribe(
        with subscriber: @escaping (ObservableEvent<Value>) -> Void
    )
    -> ObservableSubscription { return boardcaster.addSubscriber(subscriber) }
    
}
