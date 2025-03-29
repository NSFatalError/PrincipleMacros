//
//  ClosureTypeTests.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 26/01/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

@testable import PrincipleMacros
import Testing

internal struct ClosureTypeTests {

    @Test
    func testUnnamedClosure() throws {
        let type: TypeSyntax = "(Int?, [Bool]) async throws -> ()"
        let closure = try #require(ClosureType(type))

        let parameter0 = try #require(closure.parameters.first)
        #expect(parameter0.standardizedName.description == "_0")
        #expect(parameter0.standardizedType.description == "Optional<Int>")

        let parameter1 = try #require(closure.parameters.last)
        #expect(parameter1.standardizedName.description == "_1")
        #expect(parameter1.standardizedType.description == "Array<Bool>")

        #expect(closure.trimmedAsyncSpecifier?.description == "async")
        #expect(closure.standardizedThrowsClause?.description == "throws")
        #expect(closure.standardizedReturnType.description == "Void")
    }

    @Test
    func testNamedClosure() throws {
        let type: TypeSyntax = "(_ value: Int!, _ argument: (first: String, [Int])) throws(SomeError) -> String?"
        let closure = try #require(ClosureType(type))

        let parameter0 = try #require(closure.parameters.first)
        #expect(parameter0.standardizedName.description == "value")
        #expect(parameter0.standardizedType.description == "Optional<Int>")

        let parameter1 = try #require(closure.parameters.last)
        #expect(parameter1.standardizedName.description == "argument")
        #expect(parameter1.standardizedType.description == "(first: String, Array<Int>)")

        #expect(closure.trimmedAsyncSpecifier == nil)
        #expect(closure.standardizedThrowsClause?.description == "throws(SomeError)")
        #expect(closure.standardizedReturnType.description == "Optional<String>")
    }

    @Test
    func testMixedClosure() throws {
        let type: TypeSyntax = "(_ value: Bool, String.Key) -> Void"
        let closure = try #require(ClosureType(type))

        let parameter0 = try #require(closure.parameters.first)
        #expect(parameter0.standardizedName.description == "value")
        #expect(parameter0.standardizedType.description == "Bool")

        let parameter1 = try #require(closure.parameters.last)
        #expect(parameter1.standardizedName.description == "_1")
        #expect(parameter1.standardizedType.description == "String.Key")

        #expect(closure.trimmedAsyncSpecifier == nil)
        #expect(closure.standardizedThrowsClause == nil)
        #expect(closure.standardizedReturnType.description == "Void")
    }

    @Test
    func testAttributedClosure() throws {
        let type: TypeSyntax = "@Sendable () -> Void"
        let closure = try #require(ClosureType(type))
        let attribute = try #require(closure.attributes.first)
        #expect(attribute.trimmedDescription == "@Sendable")
    }
}
