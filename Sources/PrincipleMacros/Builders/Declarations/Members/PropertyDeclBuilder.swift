//
//  PropertyDeclBuilder.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 26/01/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntaxMacros

public protocol PropertyDeclBuilder: MemberDeclBuilder {

    var property: Property { get }
}

extension PropertyDeclBuilder {

    public var basicDeclaration: any BasicDeclSyntax {
        property.declaration
    }
}
