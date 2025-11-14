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
}

extension GlobalActorIsolation {

    public static func resolved(
        for declaration: some TypeDeclSyntax,
        preferred: ExplicitGlobalActorIsolation?
    ) -> Self? {
        _resolved(
            in: CollectionOfOne(Syntax(declaration)),
            preferred: preferred
        )
    }

    public static func resolved(
        for declaration: some BasicDeclSyntax,
        in lexicalContext: [Syntax],
        preferred: ExplicitGlobalActorIsolation?
    ) -> Self? {
        _resolved(
            in: CollectionOfOne(Syntax(declaration)) + lexicalContext,
            preferred: preferred
        )
    }

    private static func _resolved(
        in fullContext: some Collection<Syntax>,
        preferred: ExplicitGlobalActorIsolation?
    ) -> Self? {
        if let preferred = preferred?.underlying {
            return preferred
        }

        for syntax in fullContext {
            if let attributedSyntax = syntax.asProtocol((any WithAttributesSyntax).self),
               let inherited = attributedSyntax.globalActorIsolation {
                return inherited
            }
            if syntax.isProtocol((any DeclGroupSyntax).self) {
                break
            }
        }

        return nil
    }
}

extension SyntaxStringInterpolation {

    public mutating func appendInterpolation(_ isolation: GlobalActorIsolation?) {
        let node = isolation?.standardizedAttribute.withTrailingSpace
        appendInterpolation(node)
    }
}
