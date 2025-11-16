//
//  WithModifiersSyntax.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 12/01/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntaxMacros

extension WithModifiersSyntax {

    public var globalActorIsolation: GlobalActorIsolation? {
        let modifier = modifiers.first { modifier in
            modifier.name.tokenKind == .keyword(.nonisolated)
        }
        if let modifier {
            return .nonisolated(trimmedModifer: modifier.trimmed)
        }
        return nil
    }
}

extension WithModifiersSyntax {

    public var accessControlLevel: AccessControlLevel? {
        accessControlLevel(detail: nil)
    }

    public var setterAccessControlLevel: AccessControlLevel? {
        accessControlLevel(detail: .identifier("set"))
            ?? accessControlLevel
    }

    private func accessControlLevel(detail: TokenKind?) -> AccessControlLevel? {
        modifiers.lazy
            .filter { $0.detail?.detail.tokenKind == detail }
            .compactMap { AccessControlLevel(tokenSyntax: $0.name) }
            .first
    }
}

extension WithModifiersSyntax {

    public var finalSpecifier: TokenSyntax? {
        modifiers.lazy.map(\.name).first { name in
            name.tokenKind == .keyword(.final)
        }
    }

    public var typeScopeSpecifier: TokenSyntax? {
        modifiers.lazy.map(\.name).first { name in
            switch name.tokenKind {
            case .keyword(.class), .keyword(.static):
                true
            default:
                false
            }
        }
    }
}
