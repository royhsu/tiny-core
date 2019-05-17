//
//  ObservableMapper.swift
//  TinyCore
//
//  Created by Roy Hsu on 2019/5/17.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - ObservableMapper

final class ObservableMapper<SourceValue, DestinationValue> {
    
    private let source: AnyObservable<SourceValue>
    
    private var sourceObservation: Observation?
    
    private let destination: Atomic<DestinationValue>
    
    private let destinationBroadcaster = Broadcaster<DestinationValue>()
    
    private let transform: (SourceValue) -> DestinationValue
    
    init<O>(
        source: O,
        transform: @escaping (SourceValue) -> DestinationValue
    )
    where
        O: Observable,
        O.Value == SourceValue {
            
        self.source = AnyObservable(source)
        
        self.destination = Atomic(transform(source.value))
            
        self.transform = transform
            
        self.load()
            
    }
    
    private func load() {
        
        sourceObservation = source.observe(on: .global()) { sourceChange in
            
            let destinationChange: ObservedChange<DestinationValue>
            
            switch sourceChange {
                
            case let .initial(value):
                
                destinationChange = .initial(value: self.transform(value))
                
            case let .changed(oldValue, newValue):
                
                destinationChange = .changed(
                    oldValue: self.transform(oldValue),
                    newValue: self.transform(newValue)
                )
                
            }
            
            self.destination.modify {

                $0 = destinationChange.currentValue

                self.destinationBroadcaster.notifyAll(with: destinationChange)

            }
            
        }
    
    }
    
}

// MARK: - Observable

extension ObservableMapper: Observable {
    
    var value: DestinationValue { return destination.value }
    
    func observe(
        on queue: DispatchQueue = .global(),
        observer: @escaping (ObservedChange<DestinationValue>) -> Void
    )
    -> Observation {
        
        return destinationBroadcaster.observe(on: queue, observer: observer)
        
    }
    
}
