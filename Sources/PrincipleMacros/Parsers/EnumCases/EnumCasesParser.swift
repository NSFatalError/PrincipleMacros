//
//  EnumCasesParser.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 22/01/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntaxMacros

public enum EnumCasesParser: Parser {

    public static func parse(
        declaration: some DeclSyntaxProtocol
    ) -> EnumCasesList {
        guard let declaration = EnumCaseDeclSyntax(declaration) else {
            return EnumCasesList()
        }

        return EnumCasesList(
            declaration.elements.map { element in
                EnumCase(declaration: declaration, element: element)
            }
        )
    }
}
