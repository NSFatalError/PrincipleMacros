//
//  DeclBuilder.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 26/01/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntax

public protocol DeclBuilder {

    var basicDeclaration: any BasicDeclSyntax { get }
    var settings: DeclBuilderSettings { get }

    func build() throws -> [DeclSyntax]
}

extension DeclBuilder {

    public var inheritedAccessControlLevel: TokenSyntax? {
        let settings = settings.accessControlLevel
        guard let accessControlLevel = basicDeclaration.accessControlLevel,
              let index = TokenKind.accessControlLevels.firstIndex(of: accessControlLevel.tokenKind),
              let maxAllowedIndex = Keyword.accessControlLevels.firstIndex(of: settings.maxAllowed)
        else {
            return nil
        }

        guard index <= maxAllowedIndex else {
            let tokenKind = TokenKind.accessControlLevels[maxAllowedIndex]
            return TokenSyntax(tokenKind, presence: .present).withTrailingSpace
        }

        switch settings.inheritingDeclaration {
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

    public var inheritedGlobalActorIsolation: AttributeSyntax? {
        let globalActor: AttributeSyntax? = switch settings.globalActorIsolationPreference {
        case .nonisolated:
            nil
        case let .isolated(globalActor):
            "@\(globalActor)"
        case .none:
            basicDeclaration.globalActor?.trimmed
        }
        return globalActor?.withTrailingSpace
    }
}
