//
//  DeclBuilderSettings.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 26/01/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntax

public struct DeclBuilderSettings {

    public var accessControlLevel: AccessControlLevel
    public var globalActorIsolation: ExplicitGlobalActorIsolation?

    public init(
        accessControlLevel: AccessControlLevel,
        globalActorIsolation: ExplicitGlobalActorIsolation? = nil
    ) {
        self.accessControlLevel = accessControlLevel
        self.globalActorIsolation = globalActorIsolation
    }
}

extension DeclBuilderSettings {

    public struct AccessControlLevel {

        public var inheritingDeclaration: InheritingDeclaration
        public var maxAllowed: Keyword

        public init(
            inheritingDeclaration: InheritingDeclaration,
            maxAllowed: Keyword = .public
        ) {
            self.inheritingDeclaration = inheritingDeclaration
            self.maxAllowed = maxAllowed
        }
    }
}
