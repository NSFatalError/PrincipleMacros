//
//  SwitchExprBuilder.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 07/02/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntax

public struct SwitchExprBuilder: ExprBuilder {

    private let cases: EnumCasesList
    private let subject: ExprSyntax
    private let statementsBuilder: (EnumCase) -> CodeBlockItemListSyntax

    public init(
        for cases: EnumCasesList,
        over subject: ExprSyntax,
        using statementsBuilder: @escaping (EnumCase) -> CodeBlockItemListSyntax
    ) {
        self.cases = cases
        self.subject = subject
        self.statementsBuilder = statementsBuilder
    }

    public func build() -> SwitchExprSyntax {
        SwitchExprSyntax(
            subject: subject.withLeadingSpace.withTrailingSpace,
            leftBrace: .leftBraceToken().withTrailingNewline,
            cases: switchCases()
        )
    }

    private func switchCases() -> SwitchCaseListSyntax {
        SwitchCaseListSyntax(
            cases.map { enumCase in
                .switchCase(
                    SwitchCaseSyntax("""
                    case \(switchCase(for: enumCase)):
                        \(statementsBuilder(enumCase))\n
                    """)
                )
            }
        )
    }

    private func switchCase(for enumCase: EnumCase) -> SwitchCaseItemSyntax {
        let associatedValuesPatternBuilder = AssociatedValuesListExprBuilder(
            for: enumCase,
            withLabels: false,
            using: associatedValuePattern
        )

        let memberAccessExpression = MemberAccessExprSyntax(name: enumCase.trimmedName)
        let associatedValuesPattern = associatedValuesPatternBuilder.build()

        guard !associatedValuesPattern.isEmpty else {
            return SwitchCaseItemSyntax(
                pattern: ExpressionPatternSyntax(
                    expression: memberAccessExpression
                )
            )
        }

        return SwitchCaseItemSyntax(
            pattern: ValueBindingPatternSyntax(
                bindingSpecifier: .keyword(.let).withTrailingSpace,
                pattern: ExpressionPatternSyntax(
                    expression: FunctionCallExprSyntax(
                        calledExpression: memberAccessExpression,
                        leftParen: .leftParenToken(),
                        arguments: associatedValuesPattern,
                        rightParen: .rightParenToken()
                    )
                )
            )
        )
    }

    private func associatedValuePattern(
        for associatedValue: EnumCase.AssociatedValue
    ) -> PatternExprSyntax {
        PatternExprSyntax(
            pattern: IdentifierPatternSyntax(
                identifier: associatedValue.standardizedName
            )
        )
    }
}
