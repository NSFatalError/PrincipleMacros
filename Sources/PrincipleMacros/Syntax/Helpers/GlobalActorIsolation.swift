//
//  GlobalActorIsolation.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 18/08/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntax

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
        for syntax: some WithAttributesSyntax,
        preferred: ExplicitGlobalActorIsolation? = nil
    ) -> Self? {
        if let preferred = preferred?.underlying {
            return preferred
        }
        if let inherited = syntax.globalActorIsolation {
            return inherited
        }
        return nil
    }
}

extension SyntaxStringInterpolation {

    public mutating func appendInterpolation(_ isolation: GlobalActorIsolation?) {
        appendInterpolation(isolation?.inlinableAttribute)
    }
}
