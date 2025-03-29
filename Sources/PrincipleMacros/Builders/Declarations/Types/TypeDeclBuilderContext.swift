//
//  TypeDeclBuilderContext.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 25/01/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntax

internal enum TypeDeclBuilderContext {

    case declaration
    case `extension`(TypeSyntax)
}

extension TypeDeclBuilderContext {

    @TaskLocal
    static var current = Self.declaration
}
