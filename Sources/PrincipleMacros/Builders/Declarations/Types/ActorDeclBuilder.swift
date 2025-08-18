//
//  ActorDeclBuilder.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 18/08/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntax

public protocol ActorDeclBuilder: TypeDeclBuilder {

    var declaration: ActorDeclSyntax { get }
}

extension ActorDeclBuilder {

    public var typeDeclaration: any TypeDeclSyntax {
        declaration
    }
}
