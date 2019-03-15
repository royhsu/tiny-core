//
//  Language.swift
//  AlleyCore
//
//  Created by Roy Hsu on 2019/2/28.
//  Copyright © 2019 TinyWorld. All rights reserved.
//

// MARK: - Language

public struct Language: RawRepresentable {

    public let rawValue: String

    public init?(rawValue: String) {

        guard Locale.isoLanguageCodes.contains(rawValue) else { return nil }

        self.rawValue = rawValue

    }

}

// MARK: - Locale

extension Language {

    public init?(locale: Locale) {

        guard let code = locale.languageCode else { return nil }

        self.init(rawValue: code)

    }

}

extension Language {

    public static let current = Language(locale: .current)!

}

// MARK: - CustomLocalizedStringConvertible

extension Language: CustomLocalizedStringConvertible {

    public var localizedDescription: String { return Locale.current.localizedString(forLanguageCode: rawValue)! }

}

// MARK: - CaseIterable

extension Language: CaseIterable {

    public static var allCases: [Language] = { return Locale.isoLanguageCodes.lazy.compactMap(Language.init) }()

}

// MARK: - Equatable

extension Language: Equatable { }

// MARK: - Codable

extension Language: Codable { }

// MARK: - CustomStringConvertible

extension Language: CustomStringConvertible {

    public var description: String { return rawValue }

}
