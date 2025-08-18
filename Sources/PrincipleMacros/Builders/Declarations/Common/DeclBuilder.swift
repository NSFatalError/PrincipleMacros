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
        return basicDeclaration.inlinableAccessControlLevel(
            inheritedBy: settings.inheritingDeclaration,
            maxAllowed: settings.maxAllowed
        )
    }
}

extension DeclBuilder {

    public var inheritedGlobalActorIsolation: GlobalActorIsolation? {
        if let explicit = settings.explicitGlobalActorIsolation {
            return explicit
        }
        if let inherited = basicDeclaration.globalActor?.attributeName {
            return .isolated(trimmedType: inherited.trimmed)
        }
        return .nonisolated
    }

    public var inheritedGlobalActorAttribute: AttributeSyntax? {
        inheritedGlobalActorIsolation?.inlinableAttribute
    }
}
