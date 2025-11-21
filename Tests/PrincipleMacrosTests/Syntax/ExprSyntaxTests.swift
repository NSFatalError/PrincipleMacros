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

    @Test
    func optionalLiteral() {
        let expr: ExprSyntax = "Int?"
        #expect(expr.inferredType?.description == "Optional<Int>")
    }

    @Test
    func integerLiteral() {
        let expr: ExprSyntax = "123"
        #expect(expr.inferredType?.description == "Int")
    }

    @Test
    func floatLiteral() {
        let expr: ExprSyntax = "1.23"
        #expect(expr.inferredType?.description == "Double")
    }

    @Test
    func boolLiteral() {
        let expr: ExprSyntax = "false"
        #expect(expr.inferredType?.description == "Bool")
    }

    @Test
    func stringLiteral() {
        let expr: ExprSyntax = "\"Hello\""
        #expect(expr.inferredType?.description == "String")
    }

    @Test
    func arrayLiteral() {
        let expr: ExprSyntax = "[String]"
        #expect(expr.inferredType?.description == "Array<String>")
    }

    @Test
    func dictionaryLiteral() {
        let expr: ExprSyntax = "[String: Int]"
        #expect(expr.inferredType?.description == "Dictionary<String, Int>")
    }

    @Test
    func initializer() {
        let expr: ExprSyntax = "UIView()"
        #expect(expr.inferredType?.description == "UIView")
    }

    @Test
    func genericInitializer() {
        let expr: ExprSyntax = "Dictionary<String, Int>()"
        #expect(expr.inferredType?.description == "Dictionary<String, Int>")
    }

    @Test
    func memberAccess() {
        let expr: ExprSyntax = "Options.first"
        #expect(expr.inferredType?.description == "Options")
    }

    @Test
    func functionCall() {
        let expr: ExprSyntax = "Model.create(arg: true)"
        #expect(expr.inferredType?.description == "Model")
    }

    @Test
    func nestedFunctionCall() {
        let expr: ExprSyntax = "Model.Default.create()"
        #expect(expr.inferredType?.description == "Model.Default")
    }

    @Test
    func typeReference() {
        let expr: ExprSyntax = "Model.self"
        #expect(expr.inferredType?.description == "Model.Type")
    }

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
    func composition(expr: String, expectation: String) {
        let expr: ExprSyntax = "\(raw: expr)"
        #expect(expr.inferredType?.description == expectation)
    }
}
