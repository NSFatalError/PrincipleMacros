//
//  ExprSyntaxTests.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 14/01/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

@testable import PrincipleMacros
import Testing

internal struct ExprSyntaxTests {

    struct Basic {

        @Test
        func testOptionalLiteral() {
            let expr: ExprSyntax = "Int?"
            #expect(expr.inferredType?.description == "Optional<Int>")
        }

        @Test
        func testIntegerLiteral() {
            let expr: ExprSyntax = "123"
            #expect(expr.inferredType?.description == "Int")
        }

        @Test
        func testFloatLiteral() {
            let expr: ExprSyntax = "1.23"
            #expect(expr.inferredType?.description == "Double")
        }

        @Test
        func testBoolLiteral() {
            let expr: ExprSyntax = "false"
            #expect(expr.inferredType?.description == "Bool")
        }

        @Test
        func testStringLiteral() {
            let expr: ExprSyntax = "\"Hello\""
            #expect(expr.inferredType?.description == "String")
        }

        @Test
        func testArrayLiteral() {
            let expr: ExprSyntax = "[String]"
            #expect(expr.inferredType?.description == "Array<String>")
        }

        @Test
        func testDictionaryLiteral() {
            let expr: ExprSyntax = "[String: Int]"
            #expect(expr.inferredType?.description == "Dictionary<String, Int>")
        }

        @Test
        func testInitializer() {
            let expr: ExprSyntax = "UIView()"
            #expect(expr.inferredType?.description == "UIView")
        }

        @Test
        func testGenericInitializer() {
            let expr: ExprSyntax = "Dictionary<String, Int>()"
            #expect(expr.inferredType?.description == "Dictionary<String, Int>")
        }

        @Test
        func testMemberAccess() {
            let expr: ExprSyntax = "Options.first"
            #expect(expr.inferredType?.description == "Options")
        }

        @Test
        func testFunctionCall() {
            let expr: ExprSyntax = "Model.create(arg: true)"
            #expect(expr.inferredType?.description == "Model")
        }

        @Test
        func testNestedFunctionCall() {
            let expr: ExprSyntax = "Model.Default.create()"
            #expect(expr.inferredType?.description == "Model.Default")
        }

        @Test
        func testTypeReference() {
            let expr: ExprSyntax = "Model.self"
            #expect(expr.inferredType?.description == "Model.Type")
        }
    }

    struct Complex {

        @Test(
            arguments: [
                (
                    "[String.Key: Int]()",
                    "Dictionary<String.Key, Int>"
                ),
                (
                    "Outer<Int!>.Inner<Float>?",
                    "Optional<Outer<Optional<Int>>.Inner<Float>>"
                )
            ]
        )
        func testComposition(_ composition: (String, String)) {
            let expr: ExprSyntax = "\(raw: composition.0)"
            #expect(expr.inferredType?.description == composition.1)
        }
    }
}
