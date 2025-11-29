//
//  ClassDeclBuilder.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 22/01/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntaxMacros

public protocol ClassDeclBuilder: TypeDeclBuilder {

    var declaration: ClassDeclSyntax { get }
    var trimmedSuperclassType: TypeSyntax? { get }
}

extension ClassDeclBuilder {

    public var typeDeclaration: any TypeDeclSyntax {
        declaration
    }
}

extension ClassDeclBuilder {

    public var trimmedSuperclassType: TypeSyntax? {
        nil
    }

    public var inheritedOverrideModifier: TokenSyntax? {
        trimmedSuperclassType != nil
            ? TokenSyntax(.keyword(.override), presence: .present).withTrailingSpace
            : nil
    }

    public var inheritedFinalModifier: TokenSyntax? {
        declaration.finalSpecifier?.trimmed.withTrailingSpace
    }
}
