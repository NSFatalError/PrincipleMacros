//
//  AttributedTypeSyntax.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 14/11/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntaxMacros

extension AttributedTypeSyntax {

    public init(
        globalActorIsolation: GlobalActorIsolation?,
        baseType: some TypeSyntaxProtocol
    ) {
        let specifiers: TypeSpecifierListSyntax =
            switch globalActorIsolation {
            case .nonisolated:
                [.nonisolatedTypeSpecifier(.init())]
            default:
                []
            }

        let attributes: AttributeListSyntax =
            if let attribute = globalActorIsolation?.standardizedIsolationAttribute {
                [.attribute(attribute)]
            } else {
                []
            }

        self.init(
            specifiers: specifiers,
            attributes: attributes,
            baseType: baseType
        )
    }
}
