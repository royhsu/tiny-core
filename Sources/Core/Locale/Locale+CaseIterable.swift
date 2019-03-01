//
//  Locale+CaseIterable.swift
//  AlleyCore
//
//  Created by Roy Hsu on 2019/3/1.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - CaseIterable

extension Locale: CaseIterable {
    
    public static var allCases: [Locale] = { return availableIdentifiers.map(Locale.init) }()
    
}
