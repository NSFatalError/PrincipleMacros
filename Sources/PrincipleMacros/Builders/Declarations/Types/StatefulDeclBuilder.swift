//
//  StatefulDeclBuilder.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 22/01/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntaxMacros

public protocol StatefulDeclBuilder: TypeDeclBuilder {

    var declaration: any StatefulDeclSyntax { get }
}

extension StatefulDeclBuilder {

    public var typeDeclaration: any TypeDeclSyntax {
        declaration
    }
}
