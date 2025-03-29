//
//  PatternBindingSyntax.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 12/01/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntax

extension PatternBindingSyntax {

    public var name: TokenSyntax? {
        IdentifierPatternSyntax(pattern)?.identifier
    }

    public var inferredType: TypeSyntax? {
        typeAnnotation?.type.standardized
            ?? initializer?.value.inferredType
    }
}
