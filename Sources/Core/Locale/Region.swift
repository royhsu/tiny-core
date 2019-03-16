//
//  Region.swift
//  AlleyCore
//
//  Created by Roy Hsu on 2019/2/28.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - Region

public struct Region: RawRepresentable {

    public let rawValue: String

    public init?(rawValue: String) {

        guard Locale.isoRegionCodes.contains(rawValue) else { return nil }

        self.rawValue = rawValue

    }

}

// MARK: - Locale

extension Region {

    public init?(locale: Locale) {

        guard let code = locale.regionCode else { return nil }

        self.init(rawValue: code)

    }

}

extension Region {

    public static let current = Region(locale: .current)!

}

// MARK: - CustomLocalizedStringConvertible

extension Region: CustomLocalizedStringConvertible {

    public var localizedDescription: String { return Locale.current.localizedString(forRegionCode: rawValue)! }

}

// MARK: - CaseIterable

extension Region: CaseIterable {

    public static var allCases: [Region] = { return Locale.isoRegionCodes.lazy.compactMap(Region.init) }()

}

// MARK: - Equatable

extension Region: Equatable { }

// MARK: - Codable

extension Region: Codable { }

// MARK: - CustomStringConvertible

extension Region: CustomStringConvertible {

    public var description: String { return rawValue }

}
