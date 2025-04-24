//
//  StructDeclBuilder.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 22/01/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntax

public protocol StructDeclBuilder: TypeDeclBuilder {

    var declaration: StructDeclSyntax { get }
}

extension StructDeclBuilder {

    public var typeDeclaration: any TypeDeclSyntax {
        declaration
    }
}
