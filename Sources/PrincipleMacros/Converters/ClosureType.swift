//
//  ClosureType.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 26/01/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntax

@dynamicMemberLookup
public struct ClosureType {

    public let attributes: AttributeListSyntax
    public let function: FunctionTypeSyntax
    public let parameters: [Parameter]
    public let trimmedAsyncSpecifier: TokenSyntax?
    public let standardizedThrowsClause: ThrowsClauseSyntax?
    public let standardizedReturnType: TypeSyntax

    public init?(_ syntax: some TypeSyntaxProtocol) {
        if let attributedType = AttributedTypeSyntax(syntax),
           let function = FunctionTypeSyntax(attributedType.baseType) {
            self.init(function: function, attributes: attributedType.attributes)
        } else if let function = FunctionTypeSyntax(syntax) {
            self.init(function: function)
        } else {
            return nil
        }
    }

    public init(
        function: FunctionTypeSyntax,
        attributes: AttributeListSyntax = []
    ) {
        self.attributes = attributes
        self.function = function
        self.trimmedAsyncSpecifier = function.effectSpecifiers?.asyncSpecifier?.trimmed
        self.standardizedThrowsClause = function.effectSpecifiers?.throwsClause?.standardized
        self.standardizedReturnType = function.returnClause.type.standardized

        self.parameters = function.parameters
            .enumerated()
            .map { .init($1, index: $0) }
    }

    public subscript<T>(dynamicMember keyPath: KeyPath<FunctionTypeSyntax, T>) -> T {
        function[keyPath: keyPath]
    }
}

extension ClosureType {

    public struct Parameter {

        public let element: TupleTypeElementSyntax
        public let trimmedName: TokenSyntax?
        public let standardizedName: TokenSyntax
        public let standardizedType: TypeSyntax

        fileprivate init(_ element: TupleTypeElementSyntax, index: Int) {
            self.element = element
            self.trimmedName = element.secondName?.trimmed
            self.standardizedName = trimmedName ?? .identifier("_\(index)")
            self.standardizedType = element.type.standardized
        }
    }
}
