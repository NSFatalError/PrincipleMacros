//
//  EnumCase.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 22/01/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntax

@dynamicMemberLookup
public final class EnumCase: ParserResult {

    public let declaration: EnumCaseDeclSyntax
    public let element: EnumCaseElementSyntax
    public let trimmedName: TokenSyntax
    public let associatedValues: [AssociatedValue]

    init(
        declaration: EnumCaseDeclSyntax,
        element: EnumCaseElementSyntax
    ) {
        self.declaration = declaration
        self.element = element
        self.trimmedName = element.name.trimmed

        self.associatedValues = element.parameterClause?
            .parameters.enumerated()
            .map { .init($1, index: $0) }
            ?? []
    }

    public subscript<T>(dynamicMember keyPath: KeyPath<EnumCaseDeclSyntax, T>) -> T {
        declaration[keyPath: keyPath]
    }
}

extension EnumCase {

    public struct AssociatedValue {

        public let parameter: EnumCaseParameterSyntax
        public let trimmedName: TokenSyntax?
        public let standardizedName: TokenSyntax
        public let standardizedType: TypeSyntax

        fileprivate init(_ parameter: EnumCaseParameterSyntax, index: Int) {
            self.parameter = parameter
            self.trimmedName = parameter.firstName?.trimmed
            self.standardizedName = trimmedName ?? .identifier("_\(index)")
            self.standardizedType = parameter.type.standardized
        }
    }
}
