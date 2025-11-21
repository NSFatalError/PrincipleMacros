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
        modifiers.lazy
            .compactMap(\.globalActorIsolation)
            .first
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
            .compactMap { $0.accessControlLevel(detail: detail) }
            .first
    }
}

extension WithModifiersSyntax {

    public var overrideSpecifier: TokenSyntax? {
        modifiers.lazy
            .compactMap(\.overrideSpecifier)
            .first
    }

    public var finalSpecifier: TokenSyntax? {
        modifiers.lazy
            .compactMap(\.finalSpecifier)
            .first
    }

    public var typeScopeSpecifier: TokenSyntax? {
        modifiers.lazy
            .compactMap(\.typeScopeSpecifier)
            .first
    }
}

extension DeclModifierSyntax {

    public var globalActorIsolation: GlobalActorIsolation? {
        if name.tokenKind == .keyword(.nonisolated) {
            return .nonisolated(trimmedModifer: trimmed)
        }
        return nil
    }
}

extension DeclModifierSyntax {

    public func accessControlLevel(detail: TokenKind?) -> AccessControlLevel? {
        if self.detail?.detail.tokenKind == detail {
            return AccessControlLevel(tokenSyntax: name)
        }
        return nil
    }
}

extension DeclModifierSyntax {

    public var overrideSpecifier: TokenSyntax? {
        name.tokenKind == .keyword(.override) ? name : nil
    }

    public var finalSpecifier: TokenSyntax? {
        name.tokenKind == .keyword(.final) ? name : nil
    }

    public var typeScopeSpecifier: TokenSyntax? {
        switch name.tokenKind {
        case .keyword(.class), .keyword(.static):
            name
        default:
            nil
        }
    }
}
