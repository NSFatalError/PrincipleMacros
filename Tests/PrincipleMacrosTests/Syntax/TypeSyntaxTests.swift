//
//  TypeSyntaxTests.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 15/01/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

@testable import PrincipleMacros
import Testing

internal struct TypeSyntaxTests {

    struct Basic {

        @Test
        func testOptionalLiteral() {
            let expr: TypeSyntax = "Int?"
            #expect(expr.standardized.description == "Optional<Int>")
        }

        @Test
        func testImplicitlyUnwrappedOptionalLiteral() {
            let expr: TypeSyntax = "String!"
            #expect(expr.standardized.description == "Optional<String>")
        }

        @Test
        func testArrayLiteral() {
            let expr: TypeSyntax = "[String]"
            #expect(expr.standardized.description == "Array<String>")
        }

        @Test
        func testDictionaryLiteral() {
            let expr: TypeSyntax = "[String: Int]"
            #expect(expr.standardized.description == "Dictionary<String, Int>")
        }

        @Test
        func testBasicType() {
            let expr: TypeSyntax = "UIView"
            #expect(expr.standardized.description == "UIView")
        }

        @Test
        func testMemberType() {
            let expr: TypeSyntax = "UIView.Constraints"
            #expect(expr.standardized.description == "UIView.Constraints")
        }

        @Test
        func testGenericType() {
            let expr: TypeSyntax = "Cache<String, Int>"
            #expect(expr.standardized.description == "Cache<String, Int>")
        }

        @Test
        func testVoidType() {
            let expr: TypeSyntax = "()"
            #expect(expr.standardized.description == "Void")
        }

        @Test
        func testTupleType() {
            let expr: TypeSyntax = "(_ first: String, second: Int, Bool)"
            #expect(expr.standardized.description == "(_ first: String, second: Int, Bool)")
        }
    }

    struct Complex {

        @Test(
            arguments: [
                (
                    "[String.Key: Cache<String!, Int>]",
                    "Dictionary<String.Key, Cache<Optional<String>, Int>>"
                ),
                (
                    "(_ first: String?, second secondArg: [Int: Value.Nested])",
                    "(_ first: Optional<String>, second secondArg: Dictionary<Int, Value.Nested>)"
                )
            ]
        )
        func testComposition(_ composition: (String, String)) {
            let expr: TypeSyntax = "\(raw: composition.0)"
            #expect(expr.standardized.description == composition.1)
        }
    }
}
