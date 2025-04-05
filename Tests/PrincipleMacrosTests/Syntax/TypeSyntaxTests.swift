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
            let type: TypeSyntax = "Int?"
            #expect(type.standardized.description == "Optional<Int>")
        }

        @Test
        func testImplicitlyUnwrappedOptionalLiteral() {
            let type: TypeSyntax = "String!"
            #expect(type.standardized.description == "Optional<String>")
        }

        @Test
        func testArrayLiteral() {
            let type: TypeSyntax = "[String]"
            #expect(type.standardized.description == "Array<String>")
        }

        @Test
        func testDictionaryLiteral() {
            let type: TypeSyntax = "[String: Int]"
            #expect(type.standardized.description == "Dictionary<String, Int>")
        }

        @Test
        func testBasicType() {
            let type: TypeSyntax = "UIView"
            #expect(type.standardized.description == "UIView")
        }

        @Test
        func testMemberType() {
            let type: TypeSyntax = "UIView.Constraints"
            #expect(type.standardized.description == "UIView.Constraints")
        }

        @Test
        func testGenericType() {
            let type: TypeSyntax = "Cache<String, Int>"
            #expect(type.standardized.description == "Cache<String, Int>")
        }

        @Test
        func testVoidType() {
            let type: TypeSyntax = "()"
            #expect(type.standardized.description == "Void")
        }

        @Test
        func testTupleType() {
            let type: TypeSyntax = "(_ first: String, second: Int, Bool)"
            #expect(type.standardized.description == "(_ first: String, second: Int, Bool)")
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
        func testComposition(type: String, expectation: String) {
            let type: TypeSyntax = "\(raw: type)"
            #expect(type.standardized.description == expectation)
        }
    }
}
