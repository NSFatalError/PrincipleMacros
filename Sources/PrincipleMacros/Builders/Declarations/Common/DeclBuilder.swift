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
        return basicDeclaration.accessControlLevel(
            inheritedBy: settings.inheritingDeclaration,
            maxAllowed: settings.maxAllowed
        )
    }

    public var inheritedGlobalActorIsolation: GlobalActorIsolation? {
        if let preferred = settings.preferredGlobalActorIsolation {
            return preferred
        }
        if let inferredType = basicDeclaration.globalActor?.attributeName.trimmed {
            return .isolated(trimmedType: inferredType)
        }
        return .nonisolated
    }
}
