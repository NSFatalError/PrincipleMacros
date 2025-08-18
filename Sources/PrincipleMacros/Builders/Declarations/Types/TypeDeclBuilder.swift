//
//  TypeDeclBuilder.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 22/01/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntax

public protocol TypeDeclBuilder: DeclBuilder {

    var typeDeclaration: any TypeDeclSyntax { get }
}

extension TypeDeclBuilder {

    public var basicDeclaration: any BasicDeclSyntax {
        typeDeclaration
    }
}

extension TypeDeclBuilder {

    public var trimmedType: TypeSyntax {
        switch TypeDeclBuilderContext.current {
        case let .extension(trimmedType):
            trimmedType
        case .declaration:
            "\(typeDeclaration.name.trimmed)"
        }
    }

    public func buildExtension(of extendedType: some TypeSyntaxProtocol) throws -> MemberBlockSyntax {
        try TypeDeclBuilderContext.$current.withValue(
            .extension(trimmedType: TypeSyntax(extendedType.trimmed)),
            operation: {
                try MemberBlockSyntax(
                    members: MemberBlockItemListSyntax(
                        build().map { decl in
                            MemberBlockItemSyntax(decl: decl).withLeadingNewlines()
                        }
                    )
                )
            }
        )
    }
}
