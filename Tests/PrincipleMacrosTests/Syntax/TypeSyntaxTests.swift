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

    @Test
    func optionalLiteral() {
        let type: TypeSyntax = "Int?"
        #expect(type.standardized.description == "Optional<Int>")
    }

    @Test
    func implicitlyUnwrappedOptionalLiteral() {
        let type: TypeSyntax = "String!"
        #expect(type.standardized.description == "Optional<String>")
    }

    @Test
    func arrayLiteral() {
        let type: TypeSyntax = "[String]"
        #expect(type.standardized.description == "Array<String>")
    }

    @Test
    func dictionaryLiteral() {
        let type: TypeSyntax = "[String: Int]"
        #expect(type.standardized.description == "Dictionary<String, Int>")
    }

    @Test
    func basicType() {
        let type: TypeSyntax = "UIView"
        #expect(type.standardized.description == "UIView")
    }

    @Test
    func memberType() {
        let type: TypeSyntax = "UIView.Constraints"
        #expect(type.standardized.description == "UIView.Constraints")
    }

    @Test
    func genericType() {
        let type: TypeSyntax = "Cache<String, Int>"
        #expect(type.standardized.description == "Cache<String, Int>")
    }

    @Test
    func voidType() {
        let type: TypeSyntax = "()"
        #expect(type.standardized.description == "Void")
    }

    @Test
    func tupleType() {
        let type: TypeSyntax = "(_ first: String, second: Int, Bool)"
        #expect(type.standardized.description == "(_ first: String, second: Int, Bool)")
    }

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
    func composition(type: String, expectation: String) {
        let type: TypeSyntax = "\(raw: type)"
        #expect(type.standardized.description == expectation)
    }
}
