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
    func expressionExtraction() throws {
        let extractor = try makeExtractor(from: "#MyMacro(value: Type.make())")
        let extracted = extractor.expression(withLabel: "value")
        let expected: ExprSyntax = "Type.make()"
        #expect(extracted?.description == expected.description)
    }

    @Test
    func unnamedExpressionExtraction() throws {
        let extractor = try makeExtractor(from: "#MyMacro(value: Type.make(), 123)")
        let extracted = extractor.expression(withLabel: nil)
        let expected: ExprSyntax = "123"
        #expect(extracted?.description == expected.description)
    }

    @Test
    func overlappingExpressionExtraction() throws {
        let extractor = try makeExtractor(from: "#MyMacro(Type.make(), 123)")
        let firstExtracted = extractor.expression(withLabel: nil)
        let firstExpected: ExprSyntax = "Type.make()"
        #expect(firstExtracted?.description == firstExpected.description)

        let secondExtracted = extractor.expression(withLabel: nil)
        let secondExpected: ExprSyntax = "123"
        #expect(secondExtracted?.description == secondExpected.description)
    }

    @Test
    func missingExpressionExtraction() throws {
        let extractor = try makeExtractor(from: #"#MyMacro(arg: Type.make())"#)
        let extracted = extractor.expression(withLabel: "value")
        #expect(extracted == nil)
    }
}

extension ParameterExtractorTests {

    @Test
    func trailingClosureExtraction() throws {
        let extractor = try makeExtractor(from: "#MyMacro { _ in }")
        let extracted = extractor.trailingClosure(withLabel: "operation")
        #expect(extracted?.description == "{ _ in }")
    }

    @Test
    func trailingClosureReferenceExtraction() throws {
        let extractor = try makeExtractor(from: "#MyMacro(operation: perform)")
        let extracted = extractor.trailingClosure(withLabel: "operation")
        #expect(extracted?.description == "perform")
    }
}

extension ParameterExtractorTests {

    @Test(
        arguments: [
            "private",
            "fileprivate",
            "internal",
            "package",
            "public",
            "open"
        ]
    )
    func accessControlLevelExtraction(_ level: String) throws {
        let extractor = try makeExtractor(from: "#MyMacro(.\(raw: level))")
        let extracted = try #require(try extractor.accessControlLevel(withLabel: nil))
        #expect(String(describing: extracted).hasSuffix(level))
    }

    @Test
    func unexpectedSyntaxWhenPerformingAccessControlLevelExtraction() throws {
        let extractor = try makeExtractor(from: "#MyMacro(.didSet)")
        #expect(throws: ParameterExtractionError.unexpectedSyntaxType) {
            try extractor.accessControlLevel(withLabel: nil)
        }
    }
}

extension ParameterExtractorTests {

    @Test
    func rawStringExtraction() throws {
        let extractor = try makeExtractor(from: #"#MyMacro(string: "arg")"#)
        let extracted = try extractor.rawString(withLabel: "string")
        #expect(extracted == "arg")
    }

    @Test
    func unexpectedSyntaxWhenPerformingRawStringExtraction() throws {
        let extractor = try makeExtractor(from: #"#MyMacro(string: reference.arg)"#)
        #expect(throws: ParameterExtractionError.unexpectedSyntaxType) {
            try extractor.rawString(withLabel: "string")
        }
    }
}

extension ParameterExtractorTests {

    @Test(
        arguments: [
            "MainActor",
            "SomeType.SomeActor"
        ]
    )
    func globalActorExtraction(_ isolation: String) throws {
        let extractor = try makeExtractor(from: "#MyMacro(isolation: \(raw: isolation).self)")
        let extracted = try extractor.globalActorIsolation(withLabel: "isolation")
        #expect(extracted?.standardizedIsolationType?.trimmedDescription == isolation)
    }

    @Test
    func explicitNilGlobalActorExtraction() throws {
        let extractor = try makeExtractor(from: "#MyMacro(isolation: nil)")
        let extracted = try extractor.globalActorIsolation(withLabel: "isolation")
        #expect(extracted?.trimmedNonisolatedModifier?.trimmedDescription == "nonisolated")
    }

    @Test
    func unexpectedSyntaxWhenPerformingGlobalActorExtraction() throws {
        let extractor = try makeExtractor(from: #"#MyMacro(isolation: MainActor.Type)"#)
        #expect(throws: ParameterExtractionError.unexpectedSyntaxType) {
            try extractor.globalActorIsolation(withLabel: "isolation")
        }
    }
}

extension ParameterExtractorTests {

    @Test(
        arguments: [
            "MyType",
            "SomeType.MyType"
        ]
    )
    func typeExtraction(_ type: String) throws {
        let extractor = try makeExtractor(from: "#MyMacro(type: \(raw: type).self)")
        let extracted = try extractor.type(withLabel: "type")
        #expect(extracted?.trimmedDescription == type)
    }

    @Test
    func unexpectedSyntaxWhenPerformingTypeExtraction() throws {
        let extractor = try makeExtractor(from: #"#MyMacro(type: MainActor.Type)"#)
        #expect(throws: ParameterExtractionError.unexpectedSyntaxType) {
            try extractor.type(withLabel: "type")
        }
    }
}
