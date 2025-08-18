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
        let extracted = extractor.expression(withLabel: "value")
        let expected: ExprSyntax = "Type.make()"
        #expect(extracted?.description == expected.description)
    }

    @Test
    func testUnnamedExpressionExtraction() throws {
        let extractor = try makeExtractor(from: "#MyMacro(value: Type.make(), 123)")
        let extracted = extractor.expression(withLabel: nil)
        let expected: ExprSyntax = "123"
        #expect(extracted?.description == expected.description)
    }

    @Test
    func testMissingExpressionExtraction() throws {
        let extractor = try makeExtractor(from: #"#MyMacro(arg: Type.make())"#)
        let extracted = extractor.expression(withLabel: "value")
        #expect(extracted == nil)
    }
}

extension ParameterExtractorTests {

    @Test
    func testTrailingClosureExtraction() throws {
        let extractor = try makeExtractor(from: "#MyMacro { _ in }")
        let extracted = try extractor.trailingClosure(withLabel: "operation")
        #expect(extracted?.description == "{ _ in }")
    }

    @Test
    func testTrailingClosureReferenceExtraction() throws {
        let extractor = try makeExtractor(from: "#MyMacro(operation: perform)")
        let extracted = try extractor.trailingClosure(withLabel: "operation")
        #expect(extracted?.description == "perform")
    }
}

extension ParameterExtractorTests {

    @Test
    func testRawStringExtraction() throws {
        let extractor = try makeExtractor(from: #"#MyMacro(string: "arg")"#)
        let extracted = try extractor.rawString(withLabel: "string")
        #expect(extracted == "arg")
    }

    @Test
    func testUnexpectedSyntaxWhenPerformingRawStringExtraction() throws {
        let extractor = try makeExtractor(from: #"#MyMacro(string: reference.arg)"#)
        #expect(throws: ParameterExtractionError.unexpectedSyntaxType) {
            try extractor.rawString(withLabel: "string")
        }
    }
}

extension ParameterExtractorTests {

    @Test
    func testMissingPreferredGlobalActorExtraction() throws {
        let extractor = try makeExtractor(from: "#MyMacro()")
        let extracted = try extractor.preferredGlobalActorIsolation(withLabel: "isolation")
        #expect(extracted == nil)
    }

    @Test
    func testNonisolatedPreferredGlobalActorExtraction() throws {
        let extractor = try makeExtractor(from: "#MyMacro(isolation: nil)")
        let extracted = try extractor.preferredGlobalActorIsolation(withLabel: "isolation")
        #expect(extracted == .nonisolated)
    }

    @Test(
        arguments: [
            "MainActor",
            "SomeType.SomeActor"
        ]
    )
    func testIsolatedPreferredGlobalActorExtraction(isolation: String) throws {
        let extractor = try makeExtractor(from: "#MyMacro(isolation: \(raw: isolation).self)")
        let extracted = try extractor.preferredGlobalActorIsolation(withLabel: "isolation")
        #expect(extracted?.attribute?.description == "@\(isolation)")
    }

    @Test
    func testUnexpectedSyntaxWhenPerformingPreferredGlobalActorExtraction() throws {
        let extractor = try makeExtractor(from: #"#MyMacro(isolation: MainActor.Type)"#)
        #expect(throws: ParameterExtractionError.unexpectedSyntaxType) {
            try extractor.preferredGlobalActorIsolation(withLabel: "isolation")
        }
    }
}
