//
//  WithModifiersSyntax.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 12/01/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntax

extension WithModifiersSyntax {

    public var finalSpecifier: TokenSyntax? {
        modifiers.lazy.map(\.name).first { name in
            name.tokenKind == .keyword(.final)
        }
    }

    public var typeScopeSpecifier: TokenSyntax? {
        modifiers.lazy.map(\.name).first { name in
            TokenKind.typeScopeSpecifiers.contains(name.tokenKind)
        }
    }
}

extension WithModifiersSyntax {

    public var accessControlLevel: TokenSyntax? {
        accessControlLevel(detail: nil)
    }

    public var setterAccessControlLevel: TokenSyntax? {
        accessControlLevel(detail: .identifier("set")) ?? accessControlLevel
    }

    private func accessControlLevel(detail: TokenKind?) -> TokenSyntax? {
        modifiers.lazy
            .filter { $0.detail?.detail.tokenKind == detail }
            .map(\.name)
            .first { TokenKind.accessControlLevels.contains($0.tokenKind) }
    }
}

extension WithModifiersSyntax {

    public func accessControlLevel(
        inheritedBy inheritingDeclaration: InheritingDeclaration,
        maxAllowed: Keyword
    ) -> TokenSyntax? {
        guard let accessControlLevel,
              let index = TokenKind.accessControlLevels.firstIndex(of: accessControlLevel.tokenKind),
              let maxAllowedIndex = Keyword.accessControlLevels.firstIndex(of: maxAllowed)
        else {
            return nil
        }

        guard index <= maxAllowedIndex else {
            let tokenKind = TokenKind.accessControlLevels[maxAllowedIndex]
            return TokenSyntax(tokenKind, presence: .present).withTrailingSpace
        }

        switch inheritingDeclaration {
        case .member:
            if let internalIndex = Keyword.accessControlLevels.firstIndex(of: .internal),
               index <= internalIndex {
                return nil
            }
        case .peer:
            break
        }

        return accessControlLevel.trimmed.withTrailingSpace
    }
}

extension TokenKind {

    fileprivate static let typeScopeSpecifiers = Keyword.typeScopeSpecifiers
        .map(TokenKind.keyword)

    fileprivate static let accessControlLevels = Keyword.accessControlLevels
        .map(TokenKind.keyword)
}

extension Keyword {

    fileprivate static let typeScopeSpecifiers: [Keyword] = [
        .static,
        .class
    ]

    fileprivate static let accessControlLevels: [Keyword] = [
        .private,
        .fileprivate,
        .internal,
        .package,
        .public,
        .open
    ]
}
