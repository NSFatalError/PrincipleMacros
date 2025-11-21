//
//  WithModifiersSyntax+GlobalActorIsolation.swift
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

extension DeclModifierSyntax {

    public var globalActorIsolation: GlobalActorIsolation? {
        if name.tokenKind == .keyword(.nonisolated) {
            return .nonisolated(trimmedModifer: trimmed)
        }
        return nil
    }
}
