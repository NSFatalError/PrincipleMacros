//
//  EnumCasesParser.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 22/01/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntax
import SwiftSyntaxMacros

public enum EnumCasesParser: _Parser {

    public static func parse(
        declaration: DeclSyntaxProtocol,
        in _: MacroExpansionContext
    ) -> EnumCasesList {
        guard let declaration = EnumCaseDeclSyntax(declaration) else {
            return .init()
        }

        return EnumCasesList(
            declaration.elements.map { element in
                EnumCase(declaration: declaration, element: element)
            }
        )
    }
}
