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
    var preferredGlobalActorIsolation: ExplicitGlobalActorIsolation? { get }
    var accessControlLevelInheritanceSettings: AccessControlLevelInheritanceSettings { get }

    func build() throws -> [DeclSyntax]
}

extension DeclBuilder {

    public var inheritedAccessControlLevel: TokenSyntax? {
        basicDeclaration.inlinableAccessControlLevel(
            inheritanceSettings: accessControlLevelInheritanceSettings
        )
    }
}

extension DeclBuilder {

    public var globalActorIsolation: ExplicitGlobalActorIsolation? {
        nil
    }

    public var inheritedGlobalActorIsolation: GlobalActorIsolation? {
        .resolved(for: basicDeclaration, preferred: preferredGlobalActorIsolation)
    }
}
