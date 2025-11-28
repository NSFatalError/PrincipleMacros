//
//  IfConfigDeclSyntaxTests.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 21/11/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

@testable import PrincipleMacros
import Testing

internal enum IfConfigDeclSyntaxTests {

    struct EnclosingIfConfig {
        
        private func parseLastProperty(in decl: DeclSyntax) throws -> Property {
            let classDecl = try #require(decl.as(ClassDeclSyntax.self))
            let properties = try PropertiesParser.parse(memberBlock: classDecl.memberBlock)
            return try #require(properties.last)
        }

        // swiftlint:disable empty_line_after_type_declaration

        @Test
        func withoutIfConfig() throws {
            let decl: DeclSyntax = """
        class MyClass {
            var test = 123
        }
        """

            let ifConfig = try parseLastProperty(in: decl).enclosingIfConfig
            #expect(ifConfig == nil)
        }

        @Test
        func withIfConfig() throws {
            let decl: DeclSyntax = """
        class MyClass {
            #if os(macOS)
            var other = "hello"
            var test = 123
            #endif
        }
        """

            let expectation = """
        #if os(macOS)
        var test = 123
        #endif
        """

            let ifConfig = try parseLastProperty(in: decl).enclosingIfConfig
            #expect(ifConfig?.description == expectation)
        }

        @Test
        func withElseIfConfig() throws {
            let decl: DeclSyntax = """
        class MyClass {
            #if os(iOS)
            var other = "hello"
            #elseif os(macOS)
            var test = 123
            #endif
        }
        """

            let expectation = """
        #if os(iOS)
        #elseif os(macOS)
        var test = 123
        #endif
        """

            let ifConfig = try parseLastProperty(in: decl).enclosingIfConfig
            #expect(ifConfig?.description == expectation)
        }

        @Test
        func withNestedIfConfig() throws {
            let decl: DeclSyntax = """
        class MyClass {
            #if DEBUG
            var other = "hello"
            #if os(macOS)
            var test = 123
            #endif
            #endif
        }
        """

            let expectation = """
        #if DEBUG
        #if os(macOS)
        var test = 123
        #endif
        #endif
        """

            let ifConfig = try parseLastProperty(in: decl).enclosingIfConfig
            #expect(ifConfig?.description == expectation)
        }

        @Test
        func withNestedElseConfig() throws {
            let decl: DeclSyntax = """
        class MyClass {
            #if DEBUG
            var other = "hello"
            #else
                #if os(macOS)
                var test = 123
                #endif
            #endif
        }
        """

            let expectation = """
        #if DEBUG
        #else 
        #if os(macOS)
        var test = 123
        #endif
        #endif
        """

            let ifConfig = try parseLastProperty(in: decl).enclosingIfConfig
            #expect(ifConfig?.description == expectation)
        }

        @Test
        func applyToNewMembers() throws {
            let decl: DeclSyntax = """
        class MyClass {
            #if DEBUG
            var other = "hello"
            #else
                #if os(macOS)
                var test = 123
                #endif
            #endif
        }
        """

            let newMembers: MemberBlockItemListSyntax = """
        var replacement = "Hello"
        func test() {}
        """

            let expectation = """
        #if DEBUG
        #else 
        #if os(macOS)
        var replacement = "Hello"
        func test() {}
        #endif
        #endif
        """

            let property = try parseLastProperty(in: decl)
            let ifConfig = property.underlying.applyingEnclosingIfConfig(to: newMembers)
            #expect(ifConfig?.description == expectation)
        }

        // swiftlint:enable empty_line_after_type_declaration
    }
}
