//
//  ParameterExtractor.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 24/02/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntax

public struct ParameterExtractor {

    private let arguments: LabeledExprListSyntax
    private let trailingClosure: ClosureExprSyntax?

    public init(from node: some FreestandingMacroExpansionSyntax) {
        self.arguments = node.arguments
        self.trailingClosure = node.trailingClosure
    }

    public func expression(withLabel label: TokenSyntax?) throws -> ExprSyntax {
        let match = arguments.first { element in
            element.label?.trimmedDescription == label?.trimmedDescription
        }

        guard let match else {
            throw ParameterExtractionError.notFound
        }

        return match.expression.trimmed
    }

    public func rawString(withLabel label: TokenSyntax?) throws -> String {
        let rawString = try expression(withLabel: label)
            .as(StringLiteralExprSyntax.self)?
            .representedLiteralValue

        guard let rawString else {
            throw ParameterExtractionError.unexpectedSyntaxType
        }

        return rawString
    }

    public func trailingClosure(withLabel label: TokenSyntax?) throws -> ExprSyntax {
        if let trailingClosure {
            return ExprSyntax(trailingClosure)
        }
        return try expression(withLabel: label)
    }
}
