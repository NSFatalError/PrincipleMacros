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

    public static var nonisolated: Self {
        let modifier = DeclModifierSyntax(name: .keyword(.nonisolated))
        return .nonisolated(trimmedModifer: modifier)
    }
}

extension GlobalActorIsolation {

    public var trimmedNonisolatedModifier: DeclModifierSyntax? {
        switch self {
        case let .nonisolated(trimmedModifer):
            trimmedModifer
        default:
            nil
        }
    }

    public var standardizedIsolationType: TypeSyntax? {
        switch self {
        case let .isolated(standardizedType):
            standardizedType
        default:
            nil
        }
    }

    public var standardizedIsolationAttribute: AttributeSyntax? {
        if let standardizedIsolationType {
            return AttributeSyntax(attributeName: standardizedIsolationType)
        }
        return nil
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
        if let attribute = isolation?.standardizedIsolationAttribute {
            appendInterpolation(attribute.withTrailingSpace)
        } else if let modifier = isolation?.trimmedNonisolatedModifier {
            appendInterpolation(modifier.withTrailingSpace)
        }
    }
}
