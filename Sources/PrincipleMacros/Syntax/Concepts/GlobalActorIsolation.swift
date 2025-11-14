//
//  GlobalActorIsolation.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 18/08/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntaxMacros

public enum GlobalActorIsolation {

    case nonisolated(trimmedModifer: DeclModifierSyntax)
    case isolated(standardizedType: TypeSyntax)

    public var nonisolatedTrimmedModifier: DeclModifierSyntax? {
        switch self {
        case let .nonisolated(trimmedModifer):
            trimmedModifer
        default:
            nil
        }
    }

    public var isolatedStandardizedType: TypeSyntax? {
        switch self {
        case let .isolated(standardizedType):
            standardizedType
        default:
            nil
        }
    }
}

extension GlobalActorIsolation {

    public static func resolved(
        for declaration: some TypeDeclSyntax,
        preferred: Self? = nil
    ) -> Self? {
        _resolved(
            in: CollectionOfOne(Syntax(declaration)),
            preferred: preferred
        )
    }

    public static func resolved(
        for declaration: some BasicDeclSyntax,
        in lexicalContext: [Syntax],
        preferred: Self? = nil
    ) -> Self? {
        _resolved(
            in: CollectionOfOne(Syntax(declaration)) + lexicalContext,
            preferred: preferred
        )
    }

    private static func _resolved(
        in fullContext: some Collection<Syntax>,
        preferred: Self?
    ) -> Self? {
        if let preferred {
            return preferred
        }

        for syntax in fullContext {
            if let attributedSyntax = syntax.asProtocol((any WithAttributesSyntax).self),
               let inherited = attributedSyntax.globalActorIsolation {
                return inherited
            }
            if let modifiedSyntax = syntax.asProtocol((any WithModifiersSyntax).self),
               let inherited = modifiedSyntax.globalActorIsolation {
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
        switch isolation {
        case let .isolated(standardizedType):
            let attribute = AttributeSyntax(attributeName: standardizedType)
            appendInterpolation(attribute.withTrailingSpace)
        case let .nonisolated(trimmedModifier):
            appendInterpolation(trimmedModifier.withTrailingSpace)
        case nil:
            return
        }
    }
}
