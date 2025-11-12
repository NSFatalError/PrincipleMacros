//
//  ParameterExtractor.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 24/02/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntax
import SwiftParser

public struct ParameterExtractor {

    private let arguments: LabeledExprListSyntax?
    private let trailingClosure: ClosureExprSyntax?

    public init(from node: some FreestandingMacroExpansionSyntax) {
        self.arguments = node.arguments
        self.trailingClosure = node.trailingClosure
    }

    public init(from node: AttributeSyntax) {
        self.arguments = switch node.arguments {
        case let .argumentList(arguments):
            arguments
        default:
            nil
        }
        self.trailingClosure = nil
    }

    public func expression(
        withLabel label: TokenSyntax?
    ) -> ExprSyntax? {
        let match = arguments?.first { element in
            element.label?.trimmedDescription == label?.trimmedDescription
        }
        return match?.expression.trimmed
    }

    public func trailingClosure(
        withLabel label: TokenSyntax?
    ) -> ExprSyntax? {
        if let trailingClosure {
            return ExprSyntax(trailingClosure)
        }
        return expression(withLabel: label)
    }

    public func rawString(
        withLabel label: TokenSyntax?
    ) throws -> String? {
        guard let expression = expression(withLabel: label) else {
            return nil
        }

        let rawString = expression
            .as(StringLiteralExprSyntax.self)?
            .representedLiteralValue

        guard let rawString else {
            throw ParameterExtractionError.unexpectedSyntaxType
        }

        return rawString
    }

    public func globalActorIsolation(
        withLabel label: TokenSyntax?
    ) throws -> ExplicitGlobalActorIsolation? {
        guard let expression = expression(withLabel: label) else {
            return nil
        }

        if NilLiteralExprSyntax(expression) != nil {
            return .nonisolated
        }

        if let memberAccessExpression = MemberAccessExprSyntax(expression),
           let explicitType = memberAccessExpression.base?.inferredType,
           memberAccessExpression.referencesBaseType {
            let isolation = GlobalActorIsolation(standardizedType: explicitType)
            return .isolated(isolation)
        }

        throw ParameterExtractionError.unexpectedSyntaxType
    }
}
