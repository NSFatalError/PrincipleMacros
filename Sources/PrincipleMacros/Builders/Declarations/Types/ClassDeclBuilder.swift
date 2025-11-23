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
    var inferredSuperclass: TypeSyntax? { get }
}

extension ClassDeclBuilder {

    public var typeDeclaration: any TypeDeclSyntax {
        declaration
    }

    public var inferredSuperclass: TypeSyntax? {
        nil
    }

    public var inheritedOverrideModifier: TokenSyntax? {
        inferredSuperclass != nil
            ? TokenSyntax(.keyword(.override), presence: .present).withTrailingSpace
            : nil
    }
}
