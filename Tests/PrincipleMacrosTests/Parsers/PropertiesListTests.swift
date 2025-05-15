//
//  PropertiesListTests.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 15/05/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

@testable import PrincipleMacros
import SwiftSyntaxMacroExpansion
import Testing

internal struct PropertiesListTests {

    private let list: PropertiesList

    init() throws {
        let decl: DeclSyntax = """
        class Test {

            let letProp: Int? = 0
            var varProp = ""
            lazy var lazyVarProp = Optional<Int>.none

            static let staticLetProp = String(data: Data(), encoding: .utf8)
            static var staticVarProp = Int?.some(0)
            class var classVarProp: String { "" }

            var computedProp: Int? { 0 }
            var computedSettableProp: Optional<Int> {
                get { 0 }
                set {}
            }
        }
        """

        let classDecl = try #require(ClassDeclSyntax(decl))
        let context = BasicMacroExpansionContext()
        self.list = PropertiesParser.parse(memberBlock: classDecl.memberBlock, in: context)
    }

    @Test
    func testImmutable() throws {
        #expect(
            list.immutable.map(\.trimmedName.description) == [
                "letProp",
                "staticLetProp",
                "classVarProp",
                "computedProp"
            ]
        )
    }

    @Test
    func testMutable() throws {
        #expect(
            list.mutable.map(\.trimmedName.description) == [
                "varProp",
                "lazyVarProp",
                "staticVarProp",
                "computedSettableProp"
            ]
        )
    }

    @Test
    func testInstance() throws {
        #expect(
            list.instance.map(\.trimmedName.description) == [
                "letProp",
                "varProp",
                "lazyVarProp",
                "computedProp",
                "computedSettableProp"
            ]
        )
    }

    @Test
    func testType() throws {
        #expect(
            list.type.map(\.trimmedName.description) == [
                "staticLetProp",
                "staticVarProp",
                "classVarProp"
            ]
        )
    }

    @Test
    func testStored() throws {
        #expect(
            list.stored.map(\.trimmedName.description) == [
                "letProp",
                "varProp",
                "lazyVarProp",
                "staticLetProp",
                "staticVarProp"
            ]
        )
    }

    @Test
    func testComputed() throws {
        #expect(
            list.computed.map(\.trimmedName.description) == [
                "classVarProp",
                "computedProp",
                "computedSettableProp"
            ]
        )
    }

    @Test
    func testUniqueInferredTypes() throws {
        #expect(
            list.uniqueInferredTypes.map(\.description) == [
                "Optional<Int>",
                "String"
            ]
        )
    }

    @Test
    func testWithInferredType() throws {
        #expect(
            list.withInferredType(like: "Int?").map(\.trimmedName.description) == [
                "letProp",
                "lazyVarProp",
                "staticVarProp",
                "computedProp",
                "computedSettableProp"
            ]
        )
        #expect(
            list.withInferredType(like: "String").map(\.trimmedName.description) == [
                "varProp",
                "staticLetProp",
                "classVarProp"
            ]
        )
    }
}
