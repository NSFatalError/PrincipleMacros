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
            .first
    }
}

extension DeclModifierSyntax {

    public var accessControlLevel: AccessControlLevel? {
        accessControlLevel(detail: nil)
    }

    public var setterAccessControlLevel: AccessControlLevel? {
        accessControlLevel(detail: .identifier("set"))
            ?? accessControlLevel
    }

    private func accessControlLevel(detail: TokenKind?) -> AccessControlLevel? {
        if self.detail?.detail.tokenKind == detail {
            return AccessControlLevel(tokenSyntax: name)
        }
        return nil
    }
}
