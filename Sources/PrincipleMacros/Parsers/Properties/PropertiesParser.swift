//
//  PropertiesParser.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 12/01/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntaxMacros

public enum PropertiesParser: Parser {

    public static func parse(
        declaration: some DeclSyntaxProtocol
    ) throws -> PropertiesList {
        guard let declaration = VariableDeclSyntax(declaration) else {
            return .init()
        }

        return try PropertiesList(
            declaration.bindings.compactMap { binding -> Property? in
                guard let name = binding.name else {
                    throw DiagnosticsError(
                        node: declaration,
                        message: "Property cannot be parsed"
                    )
                }

                guard let inferredType = binding.inferredType else {
                    throw DiagnosticsError(
                        node: declaration,
                        message: "Type of property cannot be inferred - provide it explicitly"
                    )
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
