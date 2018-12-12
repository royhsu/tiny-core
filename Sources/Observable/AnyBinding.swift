//
//  AnyBinding.swift
//  TinyCore
//
//  Created by Roy Hsu on 2018/12/12.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - AnyBinding

internal struct AnyBinding<Value>: Binding {
    
    internal private(set) weak var target: AnyObject?
    
    private let _update: (Value?) -> Void
    
    init<B: Binding>(_ binding: B) where B.Value == Value {
        
        self.target = binding.target
        
        self._update = binding.update
        
    }
    
    internal func update(with value: Value?) { _update(value) }
    
}

