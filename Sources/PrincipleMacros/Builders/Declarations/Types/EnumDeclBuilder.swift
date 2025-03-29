//
//  EnumDeclBuilder.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 22/01/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntax

public protocol EnumDeclBuilder: TypeDeclBuilder {

    var declaration: EnumDeclSyntax { get }
}

extension EnumDeclBuilder {

    public var typeDeclaration: TypeDeclSyntax {
        declaration
    }
}
