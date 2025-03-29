//
//  EnumCasesParserTests.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 22/01/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

@testable import PrincipleMacros
import Testing

internal struct EnumCasesParserTests {

    private let context = DiagnosticContextMock()

    @Test
    func testEnumCase() throws {
        let decl: DeclSyntax = """
        case myCase
        """
        let enumCase = try #require(EnumCasesParser.parse(declaration: decl, in: context).first)
        #expect(enumCase.trimmedName.description == "myCase")
        #expect(enumCase.associatedValues.isEmpty)
    }

    @Test
    func testEnumCaseWithUnnamedAssociatedValue() throws {
        let decl: DeclSyntax = """
        case myCase(Int?)
        """
        let enumCase = try #require(EnumCasesParser.parse(declaration: decl, in: context).first)
        #expect(enumCase.trimmedName.description == "myCase")

        let associatedValue0 = try #require(enumCase.associatedValues.first)
        #expect(associatedValue0.standardizedName.description == "_0")
        #expect(associatedValue0.standardizedType.description == "Optional<Int>")
    }

    @Test
    func testEnumCaseWithNamedAssociatedValue() throws {
        let decl: DeclSyntax = """
        case myCase(values: [String])
        """
        let enumCase = try #require(EnumCasesParser.parse(declaration: decl, in: context).first)
        #expect(enumCase.trimmedName.description == "myCase")

        let associatedValue0 = try #require(enumCase.associatedValues.first)
        #expect(associatedValue0.standardizedName.description == "values")
        #expect(associatedValue0.standardizedType.description == "Array<String>")
    }

    @Test
    func testEnumCaseWithManyAssociatedValues() throws {
        let decl: DeclSyntax = """
        case myCase(value: Int?, [String])
        """
        let enumCase = try #require(EnumCasesParser.parse(declaration: decl, in: context).first)
        #expect(enumCase.trimmedName.description == "myCase")

        let associatedValue0 = try #require(enumCase.associatedValues.first)
        #expect(associatedValue0.standardizedName.description == "value")
        #expect(associatedValue0.standardizedType.description == "Optional<Int>")

        let associatedValue1 = try #require(enumCase.associatedValues.last)
        #expect(associatedValue1.standardizedName.description == "_1")
        #expect(associatedValue1.standardizedType.description == "Array<String>")
    }
}
