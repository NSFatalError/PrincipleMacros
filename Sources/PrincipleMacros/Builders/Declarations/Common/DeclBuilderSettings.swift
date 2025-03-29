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

    public init(accessControlLevel: AccessControlLevel) {
        self.accessControlLevel = accessControlLevel
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
