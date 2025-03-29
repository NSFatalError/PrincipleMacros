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

    struct SingleLine {

        struct WithoutSignature {

            private let expr: ExprSyntax = """
            { Date.now }
            """

            @Test
            func testInterpolation() throws {
                let closure = expr.expanded(nestingLevel: 2)
                let interpolation: ExprSyntax = """
                .init(
                    parameter: .init(
                        closure: \(closure),
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
        }

        struct WithSignature {

            private let expr: ExprSyntax = """
            { [weak self] arg0, _ -> String in arg0 }
            """

            @Test
            func testInterpolation() throws {
                let closure = expr.expanded(nestingLevel: 2)
                let interpolation: ExprSyntax = """
                .init(
                    parameter: .init(
                        closure: \(closure),
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
        }
    }

    struct MultiLine {

        private let expr: ExprSyntax = """
        { [weak self] arg0, arg1 -> String in
            if arg0 > 0 {
                return String(arg0)
            } else if arg1 {
                return "Test"
            }
            return ""
        }
        """

        @Test
        func testInterpolation() throws {
            let closure = expr.expanded(nestingLevel: 2)
            let interpolation: ExprSyntax = """
            .init(
                parameter: .init(
                    closure: \(closure),
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
}
