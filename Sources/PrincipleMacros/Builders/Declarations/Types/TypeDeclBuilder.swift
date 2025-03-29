//
//  TypeDeclBuilder.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 22/01/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntax

public protocol TypeDeclBuilder: DeclBuilder {

    var typeDeclaration: TypeDeclSyntax { get }
}

extension TypeDeclBuilder {

    public var basicDeclaration: BasicDeclSyntax {
        typeDeclaration
    }
}

extension TypeDeclBuilder {

    public var trimmedTypeName: TypeSyntax {
        switch TypeDeclBuilderContext.current {
        case let .extension(extendedType):
            extendedType.trimmed
        case .declaration:
            "\(typeDeclaration.name.trimmed)"
        }
    }

    public func buildExtension(of extendedType: some TypeSyntaxProtocol) throws -> MemberBlockSyntax {
        try TypeDeclBuilderContext.$current.withValue(
            .extension(TypeSyntax(extendedType)),
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
