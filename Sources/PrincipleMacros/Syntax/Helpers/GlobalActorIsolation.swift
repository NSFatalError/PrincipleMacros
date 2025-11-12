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

    public var inlinableAttribute: AttributeSyntax {
        let attribute = AttributeSyntax(attributeName: standardizedType)
        return attribute.withTrailingSpace
    }
}

extension SyntaxStringInterpolation {

    public mutating func appendInterpolation(_ isolation: GlobalActorIsolation?) {
        appendInterpolation(isolation?.inlinableAttribute)
    }
}
