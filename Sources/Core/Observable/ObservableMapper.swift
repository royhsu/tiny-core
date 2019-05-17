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
    
    private let transform: (SourceValue) -> DestinationValue
    
    init<O>(
        source: O,
        transform: @escaping (SourceValue) -> DestinationValue
    )
    where
        O: Observable,
        O.Value == SourceValue {
            
        self.source = AnyObservable(source)
        
        self.transform = transform
            
    }
    
}

// MARK: - Observable

extension ObservableMapper: Observable {
    
    var value: DestinationValue { return transform(source.value) }
    
    func observe(
        on queue: DispatchQueue,
        observer: @escaping (ObservedChange<DestinationValue>) -> Void
    )
    -> Observation {
        
        return source.observe(on: queue) { sourceChange in
            
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
            
            observer(destinationChange)
            
        }
        
    }
    
}
