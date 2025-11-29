//
//  PropertyDeclAccessorBuilder.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 28/11/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntaxMacros

public protocol PropertyDeclAccessorBuilder: PropertyDeclBuilder {

    func buildAccessors() throws -> [AccessorDeclSyntax]
}

extension PropertyDeclAccessorBuilder {

    public func build() throws -> [DeclSyntax] {
        try buildAccessors().map(DeclSyntax.init)
    }
}
