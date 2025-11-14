//
//  ParameterExtractor.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 24/02/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntaxMacros

public final class ParameterExtractor {

    private var arguments: LabeledExprListSyntax?
    private var trailingClosure: ClosureExprSyntax?

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
}

extension ParameterExtractor {

    public func expression(
        withLabel label: TokenSyntax?
    ) -> ExprSyntax? {
        guard let arguments else {
            return nil
        }

        for (index, element) in zip(arguments.indices, arguments) {
            if element.label?.trimmedDescription == label?.trimmedDescription {
                self.arguments?.remove(at: index)
                return element.expression.trimmed
            }
        }

        return nil
    }

    public func requiredExpression(
        withLabel label: TokenSyntax?
    ) throws -> ExprSyntax {
        guard let expression = expression(withLabel: label) else {
            throw ParameterExtractionError.missingRequirement
        }
        return expression
    }
}

extension ParameterExtractor {

    public func trailingClosure(
        withLabel label: TokenSyntax?
    ) -> ExprSyntax? {
        if let trailingClosure = trailingClosure.take() {
            return ExprSyntax(trailingClosure)
        }
        return expression(withLabel: label)
    }

    public func requiredTrailingClosure(
        withLabel label: TokenSyntax?
    ) throws -> ExprSyntax {
        guard let trailingClosure = trailingClosure(withLabel: label) else {
            throw ParameterExtractionError.missingRequirement
        }
        return trailingClosure
    }
}

extension ParameterExtractor {

    public func accessControlLevel(
        withLabel label: TokenSyntax?
    ) throws -> AccessControlLevel? {
        guard let expression = expression(withLabel: label) else {
            return nil
        }

        let baseName = expression
            .as(MemberAccessExprSyntax.self)?
            .declName
            .baseName
            .trimmedDescription

        switch baseName {
        case "private":
            return .private
        case "fileprivate":
            return .fileprivate
        case "internal":
            return .internal
        case "package":
            return .package
        case "public":
            return .public
        case "open":
            return .open
        default:
            throw ParameterExtractionError.unexpectedSyntaxType
        }
    }

    public func requiredAccessControlLevel(
        withLabel label: TokenSyntax?
    ) throws -> AccessControlLevel {
        guard let level = try accessControlLevel(withLabel: label) else {
            throw ParameterExtractionError.missingRequirement
        }
        return level
    }
}

extension ParameterExtractor {

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

    public func requiredRawString(
        withLabel label: TokenSyntax?
    ) throws -> String {
        guard let rawString = try rawString(withLabel: label) else {
            throw ParameterExtractionError.missingRequirement
        }
        return rawString
    }
}

extension ParameterExtractor {

    public func globalActorIsolation(
        withLabel label: TokenSyntax?
    ) throws -> GlobalActorIsolation? {
        guard let expression = expression(withLabel: label) else {
            return nil
        }

        if NilLiteralExprSyntax(expression) != nil {
            let isolation = DeclModifierSyntax(name: .keyword(.nonisolated))
            return .nonisolated(trimmedModifer: isolation)
        }

        if let memberAccessExpression = MemberAccessExprSyntax(expression),
           let explicitType = memberAccessExpression.base?.inferredType,
           memberAccessExpression.referencesBaseType {
            return .isolated(standardizedType: explicitType.standardized)
        }

        throw ParameterExtractionError.unexpectedSyntaxType
    }

    public func requiredGlobalActorIsolation(
        withLabel label: TokenSyntax?
    ) throws -> GlobalActorIsolation {
        guard let isolation = try globalActorIsolation(withLabel: label) else {
            throw ParameterExtractionError.missingRequirement
        }
        return isolation
    }
}
