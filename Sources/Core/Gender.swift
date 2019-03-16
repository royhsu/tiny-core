//
//  Gender.swift
//  AlleyCore
//
//  Created by Roy Hsu on 2019/2/27.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - Gender

public enum Gender: String {

    case male, female

}

// MARK: - Equatable

extension Gender: Equatable { }

// MARK: - Codable

extension Gender: Codable { }

// MARK: - CaseIterable

extension Gender: CaseIterable { }

// MARK: - CustomLocalizedStringConvertible

extension Gender: CustomLocalizedStringConvertible {

    public var localizedDescription: String {

        switch self {

        case .male:

            return NSLocalizedString(
                "Male",
                comment: ""
            )

        case .female:

            return NSLocalizedString(
                "Female",
                comment: ""
            )

        }

    }

}
