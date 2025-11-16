//
//  FunctionDeclBuilder.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 13/11/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntaxMacros

public protocol FunctionDeclBuilder: MemberDeclBuilder {

    var declaration: FunctionDeclSyntax { get }
}

extension FunctionDeclBuilder {

    public var basicDeclaration: any BasicDeclSyntax {
        declaration
    }
}
