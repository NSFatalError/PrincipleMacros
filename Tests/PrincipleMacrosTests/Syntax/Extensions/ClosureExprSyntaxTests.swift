//
//  ClosureExprSyntaxTests.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 03/02/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

@testable import PrincipleMacros
import Testing

internal struct ClosureExprSyntaxTests {

    @Test
    func withoutSignature() {
        let expr: ExprSyntax = """
        { Date.now }
        """

        let interpolation: ExprSyntax = """
        .init(
            parameter: .init(
                closure: \(expr.expanded(nestingLevel: 2)),
                value: "Foo"
            )
        )
        """

        let expectation = """
        .init(
            parameter: .init(
                closure: {
                    Date.now
                },
                value: "Foo"
            )
        )
        """

        #expect(interpolation.description == expectation)
    }

    @Test
    func withSignature() {
        let expr: ExprSyntax = """
        { [weak self] arg0, _ -> String in arg0 }
        """

        let interpolation: ExprSyntax = """
        .init(
            parameter: .init(
                closure: \(expr.expanded(nestingLevel: 2)),
                value: "Foo"
            )
        )
        """

        let expectation = """
        .init(
            parameter: .init(
                closure: { [weak self] arg0, _ -> String in
                    arg0
                },
                value: "Foo"
            )
        )
        """

        #expect(interpolation.description == expectation)
    }

    @Test
    func multiline() {
        let expr: ExprSyntax = """
        { [weak self] arg0, arg1 -> String in
            if arg0 > 0 {
                return String(arg0)
            } else if arg1 {
                return "Test"
            }
            return ""
        }
        """

        let interpolation: ExprSyntax = """
        .init(
            parameter: .init(
                closure: \(expr.expanded(nestingLevel: 2)),
                value: "Foo"
            )
        )
        """

        let expectation = """
        .init(
            parameter: .init(
                closure: { [weak self] arg0, arg1 -> String in
                    if arg0 > 0 {
                        return String(arg0)
                    } else if arg1 {
                        return "Test"
                    }
                    return ""
                },
                value: "Foo"
            )
        )
        """

        #expect(interpolation.description == expectation)
    }
}
