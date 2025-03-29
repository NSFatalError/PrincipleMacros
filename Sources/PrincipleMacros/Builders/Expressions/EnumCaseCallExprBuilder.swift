//
//  EnumCaseCallExprBuilder.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 07/02/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntax

public struct EnumCaseCallExprBuilder<Expr>: ExprBuilder
where Expr: ExprSyntaxProtocol {

    private let enumCase: EnumCase
    private let assignmentBuilder: (EnumCase.AssociatedValue) -> Expr

    public init(
        for enumCase: EnumCase,
        using assignmentBuilder: @escaping (EnumCase.AssociatedValue) -> Expr
    ) {
        self.enumCase = enumCase
        self.assignmentBuilder = assignmentBuilder
    }

    public func build() -> ExprSyntax {
        let assignmentsBuilder = AssociatedValuesListExprBuilder(
            for: enumCase,
            withLabels: true,
            using: assignmentBuilder
        )

        let memberAccessExpression = MemberAccessExprSyntax(name: enumCase.trimmedName)
        let assignments = assignmentsBuilder.build()

        guard !assignments.isEmpty else {
            return ExprSyntax(memberAccessExpression)
        }

        return ExprSyntax(
            FunctionCallExprSyntax(
                calledExpression: memberAccessExpression,
                leftParen: .leftParenToken(),
                arguments: assignments,
                rightParen: .rightParenToken()
            )
        )
    }
}
