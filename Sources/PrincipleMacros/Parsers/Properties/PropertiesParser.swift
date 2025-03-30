//
//  PropertiesParser.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 12/01/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntax
import SwiftSyntaxMacros

public enum PropertiesParser: _Parser {

    public static func parse(
        declaration: DeclSyntaxProtocol,
        in context: MacroExpansionContext
    ) -> PropertiesList {
        guard let declaration = VariableDeclSyntax(declaration) else {
            return .init()
        }

        return PropertiesList(
            declaration.bindings.compactMap { binding -> Property? in
                guard let name = binding.name else {
                    context.diagnose(
                        node: declaration,
                        errorMessage: "Property cannot be parsed"
                    )
                    return nil
                }

                guard let inferredType = binding.inferredType else {
                    context.diagnose(
                        node: declaration,
                        errorMessage: "Type of property cannot be inferred - provide it explicitly"
                    )
                    return nil
                }

                return Property(
                    declaration: declaration,
                    binding: binding,
                    name: name,
                    inferredType: inferredType
                )
            }
        )
    }
}
