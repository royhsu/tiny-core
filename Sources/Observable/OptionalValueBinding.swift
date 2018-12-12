//
//  OptionalValueBinding.swift
//  TinyCore
//
//  Created by Roy Hsu on 2018/12/12.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - OptionalValueBinding

internal final class OptionalValueBinding<Target: AnyObject, T, U>: Binding {
    
    private final let transform: (T?) -> U?
    
    private final let queue: DispatchQueue
    
    public final var target: AnyObject? { return _target }
    
    private final weak var _target: Target?
    
    private final let keyPath: ReferenceWritableKeyPath<Target, U?>
    
    internal init(
        transform: @escaping (T?) -> U?,
        queue: DispatchQueue,
        target: Target,
        keyPath: ReferenceWritableKeyPath<Target, U?>
    ) {
        
        self.transform = transform
        
        self.queue = queue
        
        self._target = target
        
        self.keyPath = keyPath
        
    }
    
    internal final func update(with value: T?) {
        
        queue.async { [weak self] in
            
            guard let self = self else { return }
            
            self._target?[keyPath: self.keyPath] = self.transform(value)
            
        }
        
    }
    
}
