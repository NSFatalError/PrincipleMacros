//
//  GlobalActorIsolation.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 18/08/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntaxMacros

public struct GlobalActorIsolation: Hashable {

    public let standardizedType: TypeSyntax

    public var standardizedAttribute: AttributeSyntax {
        AttributeSyntax(attributeName: standardizedType)
    }

    public var inlinableAttribute: AttributeSyntax {
        standardizedAttribute.withTrailingSpace
    }
}

extension GlobalActorIsolation {

    public static func resolved(
        for syntax: some TypeDeclSyntax,
        preferred: ExplicitGlobalActorIsolation?
    ) -> Self? {
        if let preferred = preferred?.underlying {
            return preferred
        }
        if let inherited = syntax.globalActorIsolation {
            return inherited
        }
        return nil
    }

    public static func resolved(
        for syntax: some BasicDeclSyntax,
        in lexicalContext: [Syntax],
        preferred: ExplicitGlobalActorIsolation?
    ) -> Self? {
        if let preferred = preferred?.underlying {
            return preferred
        }
        if let inherited = syntax.globalActorIsolation {
            return inherited
        }
        if let declGroup = lexicalContext.first?.asProtocol((any DeclGroupSyntax).self),
           let enclosing = declGroup.asProtocol((any WithAttributesSyntax).self)?.globalActorIsolation {
            return enclosing
        }
        return nil
    }
}

extension SyntaxStringInterpolation {

    public mutating func appendInterpolation(_ isolation: GlobalActorIsolation?) {
        appendInterpolation(isolation?.inlinableAttribute)
    }
}
