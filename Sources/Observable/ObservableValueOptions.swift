//
//  ObservableValueOptions.swift
//  TinyCore
//
//  Created by Roy Hsu on 2018/9/11.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - ObservableValueOptions

public struct ObservableValueOptions: OptionSet {
    
    public let rawValue: Int
    
    /// Prevent the internal boardcaster inside a observer notifying its subscribers.
    public static let muteBroadcaster = ObservableValueOptions(rawValue: 1 << 0)
    
    public init(rawValue: Int) { self.rawValue = rawValue }
    
}
