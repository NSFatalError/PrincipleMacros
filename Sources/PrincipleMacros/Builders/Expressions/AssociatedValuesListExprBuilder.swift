//
//  AssociatedValuesListExprBuilder.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 07/02/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntax

internal struct AssociatedValuesListExprBuilder<Expr>: ExprBuilder
where Expr: ExprSyntaxProtocol {

    private let enumCase: EnumCase
    private let withLabels: Bool
    private let expressionBuilder: (EnumCase.AssociatedValue) -> Expr

    init(
        for enumCase: EnumCase,
        withLabels: Bool,
        using expressionBuilder: @escaping (EnumCase.AssociatedValue) -> Expr
    ) {
        self.enumCase = enumCase
        self.withLabels = withLabels
        self.expressionBuilder = expressionBuilder
    }

    func build() -> LabeledExprListSyntax {
        guard let lastValue = enumCase.associatedValues.last else {
            return []
        }

        var list = enumCase.associatedValues.dropLast().map { value in
            expression(for: value, withComma: true)
        }
        list.append(
            expression(for: lastValue, withComma: false)
        )

        return LabeledExprListSyntax(list)
    }

    private func expression(
        for value: EnumCase.AssociatedValue,
        withComma: Bool
    ) -> LabeledExprSyntax {
        LabeledExprSyntax(
            label: withLabels ? value.trimmedName : nil,
            colon: (withLabels && value.trimmedName != nil) ? .colonToken().withTrailingSpace : nil,
            expression: expressionBuilder(value),
            trailingComma: withComma ? .commaToken().withTrailingSpace : nil
        )
    }
}
