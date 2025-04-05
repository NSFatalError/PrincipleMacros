//
//  ParameterExtractorTests.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 05/04/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

@testable import PrincipleMacros
import Testing

internal struct ParameterExtractorTests {

    private func makeExtractor(from expr: ExprSyntax) throws -> ParameterExtractor {
        let macro = try #require(MacroExpansionExprSyntax(expr))
        return ParameterExtractor(from: macro)
    }

    @Test
    func testExpressionExtraction() throws {
        let extractor = try makeExtractor(from: "#MyMacro(value: Type.make())")
        let extracted = try extractor.expression(withLabel: "value")
        let expected: ExprSyntax = "Type.make()"
        #expect(extracted.description == expected.description)
    }

    @Test
    func testUnnamedExpressionExtraction() throws {
        let extractor = try makeExtractor(from: "#MyMacro(value: Type.make(), 123)")
        let extracted = try extractor.expression(withLabel: nil)
        let expected: ExprSyntax = "123"
        #expect(extracted.description == expected.description)
    }

    @Test
    func testTrailingClosureExtraction() throws {
        let extractor = try makeExtractor(from: "#MyMacro { _ in }")
        let extracted = try extractor.trailingClosure(withLabel: "operation")
        let expected: ExprSyntax = "{ _ in }"
        #expect(extracted.description == expected.description)
    }

    @Test
    func testTrailingClosureReferenceExtraction() throws {
        let extractor = try makeExtractor(from: "#MyMacro(operation: perform)")
        let extracted = try extractor.trailingClosure(withLabel: "operation")
        let expected: ExprSyntax = "perform"
        #expect(extracted.description == expected.description)
    }

    @Test
    func testRawStringExtraction() throws {
        let extractor = try makeExtractor(from: #"#MyMacro(string: "arg")"#)
        let extracted = try extractor.rawString(withLabel: "string")
        #expect(extracted == "arg")
    }

    @Test
    func testUnexpectedSyntaxTypeError() throws {
        let extractor = try makeExtractor(from: #"#MyMacro(string: reference.arg)"#)
        #expect(throws: ParameterExtractionError.unexpectedSyntaxType) {
            try extractor.rawString(withLabel: "string")
        }
    }

    @Test
    func testNotFoundError() throws {
        let extractor = try makeExtractor(from: #"#MyMacro(string: "arg")"#)
        #expect(throws: ParameterExtractionError.notFound) {
            try extractor.rawString(withLabel: "value")
        }
    }
}
