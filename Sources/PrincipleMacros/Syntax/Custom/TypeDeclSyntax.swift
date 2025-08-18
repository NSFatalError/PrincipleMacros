//
//  TypeDeclSyntax.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 23/01/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntax

public protocol TypeDeclSyntax: DeclGroupSyntax, NamedDeclSyntax, BasicDeclSyntax {

    var isFinal: Bool { get }
}

extension ClassDeclSyntax: TypeDeclSyntax {

    public var isFinal: Bool {
        finalSpecifier != nil
    }
}

extension ProtocolDeclSyntax: TypeDeclSyntax {

    public var isFinal: Bool {
        false
    }
}

extension ActorDeclSyntax: TypeDeclSyntax {

    public var isFinal: Bool {
        true
    }
}

extension EnumDeclSyntax: TypeDeclSyntax {

    public var isFinal: Bool {
        true
    }
}

extension StructDeclSyntax: TypeDeclSyntax {

    public var isFinal: Bool {
        true
    }
}
