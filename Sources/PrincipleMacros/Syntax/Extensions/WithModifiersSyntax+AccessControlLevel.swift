//
//  WithModifiersSyntax+AccessControlLevel.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 12/01/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntaxMacros

extension WithModifiersSyntax {

    public var accessControlLevel: AccessControlLevel? {
        modifiers.lazy
            .compactMap(\.accessControlLevel)
            .first
    }

    public var setterAccessControlLevel: AccessControlLevel? {
        modifiers.lazy
            .compactMap(\.setterAccessControlLevel)
            .first ?? accessControlLevel
    }
}

extension DeclModifierListSyntax {

    public func withAccessControlLevel(_ level: AccessControlLevel?) -> Self {
        var modifiers = filter { modifier in
            modifier.accessControlLevel == nil
                && modifier.setterAccessControlLevel == nil
        }

        if let level {
            let modifier = DeclModifierSyntax(name: level.tokenSyntax)
            modifiers.insert(modifier, at: modifiers.startIndex)
        }

        return modifiers
    }
}

extension DeclModifierSyntax {

    public var accessControlLevel: AccessControlLevel? {
        accessControlLevel(detail: nil)
    }

    public var setterAccessControlLevel: AccessControlLevel? {
        accessControlLevel(detail: .identifier("set"))
    }

    private func accessControlLevel(detail detailTokenKind: TokenKind?) -> AccessControlLevel? {
        if detail?.detail.tokenKind == detailTokenKind {
            return AccessControlLevel(tokenSyntax: name)
        }
        return nil
    }
}
