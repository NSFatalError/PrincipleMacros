//
//  DeclBuilder.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 26/01/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntaxMacros

public protocol DeclBuilder {

    var basicDeclaration: any BasicDeclSyntax { get }
    var lexicalContext: [Syntax] { get }

    var preferredGlobalActorIsolation: GlobalActorIsolation? { get }
    var preferredAccessControlLevel: AccessControlLevel? { get }

    func build() throws -> [DeclSyntax]
}

extension DeclBuilder {

    public var lexicalContext: [Syntax] {
        []
    }

    public var preferredGlobalActorIsolation: GlobalActorIsolation? {
        nil
    }

    public var preferredAccessControlLevel: AccessControlLevel? {
        nil
    }

    public var inheritedAvailability: AttributeListSyntax? {
        basicDeclaration.availability?.trimmed.withTrailingNewline
    }
}
