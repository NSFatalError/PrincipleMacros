//
//  ParameterExtractorTests.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 05/04/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

@testable import PrincipleMacros
import Testing

internal class ParameterExtractorTests {

    private func makeExtractor(from expr: ExprSyntax) throws -> ParameterExtractor {
        let macro = try #require(MacroExpansionExprSyntax(expr))
        return ParameterExtractor(from: macro)
    }
}

extension ParameterExtractorTests {

    final class Expression: ParameterExtractorTests {

        @Test
        func extraction() throws {
            let extractor = try makeExtractor(from: "#MyMacro(value: Type.make())")
            let extracted = extractor.expression(withLabel: "value")
            let expected: ExprSyntax = "Type.make()"
            #expect(extracted?.description == expected.description)
        }

        @Test
        func unnamedExtraction() throws {
            let extractor = try makeExtractor(from: "#MyMacro(value: Type.make(), 123)")
            let extracted = extractor.expression(withLabel: nil)
            let expected: ExprSyntax = "123"
            #expect(extracted?.description == expected.description)
        }

        @Test
        func overlappingExtraction() throws {
            let extractor = try makeExtractor(from: "#MyMacro(Type.make(), 123)")
            let firstExtracted = extractor.expression(withLabel: nil)
            let firstExpected: ExprSyntax = "Type.make()"
            #expect(firstExtracted?.description == firstExpected.description)

            let secondExtracted = extractor.expression(withLabel: nil)
            let secondExpected: ExprSyntax = "123"
            #expect(secondExtracted?.description == secondExpected.description)
        }

        @Test
        func missingExtraction() throws {
            let extractor = try makeExtractor(from: #"#MyMacro(arg: Type.make())"#)
            let extracted = extractor.expression(withLabel: "value")
            #expect(extracted == nil)
        }
    }
}

extension ParameterExtractorTests {

    final class TrailingClosure: ParameterExtractorTests {

        @Test
        func extraction() throws {
            let extractor = try makeExtractor(from: "#MyMacro { _ in }")
            let extracted = extractor.trailingClosure(withLabel: "operation")
            #expect(extracted?.description == "{ _ in }")
        }

        @Test
        func referenceExtraction() throws {
            let extractor = try makeExtractor(from: "#MyMacro(operation: perform)")
            let extracted = extractor.trailingClosure(withLabel: "operation")
            #expect(extracted?.description == "perform")
        }
    }
}

extension ParameterExtractorTests {

    final class AccessControlLevel: ParameterExtractorTests {

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
        func extraction(_ level: String) throws {
            let extractor = try makeExtractor(from: "#MyMacro(.\(raw: level))")
            let extracted = try #require(try extractor.accessControlLevel(withLabel: nil))
            #expect(String(describing: extracted).hasSuffix(level))
        }

        @Test
        func unexpectedSyntax() throws {
            let extractor = try makeExtractor(from: "#MyMacro(.didSet)")
            #expect(throws: ParameterExtractionError.unexpectedSyntaxType) {
                try extractor.accessControlLevel(withLabel: nil)
            }
        }
    }
}

extension ParameterExtractorTests {

    final class RawBool: ParameterExtractorTests {

        @Test(
            arguments: [
                true,
                false
            ]
        )
        func extraction(_ bool: Bool) throws {
            let extractor = try makeExtractor(from: "#MyMacro(boolean: \(raw: bool))")
            let extracted = try extractor.rawBool(withLabel: "boolean")
            #expect(extracted == bool)
        }

        @Test
        func unexpectedSyntax() throws {
            let extractor = try makeExtractor(from: #"#MyMacro(boolean: value)"#)
            #expect(throws: ParameterExtractionError.unexpectedSyntaxType) {
                try extractor.rawBool(withLabel: "boolean")
            }
        }
    }
}

extension ParameterExtractorTests {

    final class RawString: ParameterExtractorTests {

        @Test
        func extraction() throws {
            let extractor = try makeExtractor(from: #"#MyMacro(string: "arg")"#)
            let extracted = try extractor.rawString(withLabel: "string")
            #expect(extracted == "arg")
        }

        @Test
        func unexpectedSyntax() throws {
            let extractor = try makeExtractor(from: #"#MyMacro(string: reference.arg)"#)
            #expect(throws: ParameterExtractionError.unexpectedSyntaxType) {
                try extractor.rawString(withLabel: "string")
            }
        }
    }
}

extension ParameterExtractorTests {

    final class GlobalActorIsolation: ParameterExtractorTests {

        @Test(
            arguments: [
                "MainActor",
                "SomeType.SomeActor"
            ]
        )
        func extraction(_ isolation: String) throws {
            let extractor = try makeExtractor(from: "#MyMacro(isolation: \(raw: isolation).self)")
            let extracted = try extractor.globalActorIsolation(withLabel: "isolation")
            #expect(extracted?.standardizedIsolationType?.trimmedDescription == isolation)
        }

        @Test
        func nonisolatedExtraction() throws {
            let extractor = try makeExtractor(from: "#MyMacro(isolation: nil)")
            let extracted = try extractor.globalActorIsolation(withLabel: "isolation")
            #expect(extracted?.trimmedNonisolatedModifier?.trimmedDescription == "nonisolated")
        }

        @Test
        func unexpectedSyntax() throws {
            let extractor = try makeExtractor(from: #"#MyMacro(isolation: MainActor.Type)"#)
            #expect(throws: ParameterExtractionError.unexpectedSyntaxType) {
                try extractor.globalActorIsolation(withLabel: "isolation")
            }
        }
    }
}

extension ParameterExtractorTests {

    final class TypeReference: ParameterExtractorTests {

        @Test(
            arguments: [
                "MyType",
                "SomeType.MyType"
            ]
        )
        func extraction(_ type: String) throws {
            let extractor = try makeExtractor(from: "#MyMacro(type: \(raw: type).self)")
            let extracted = try extractor.type(withLabel: "type")
            #expect(extracted?.trimmedDescription == type)
        }

        @Test
        func unexpectedSyntax() throws {
            let extractor = try makeExtractor(from: #"#MyMacro(type: MainActor.Type)"#)
            #expect(throws: ParameterExtractionError.unexpectedSyntaxType) {
                try extractor.type(withLabel: "type")
            }
        }
    }
}
