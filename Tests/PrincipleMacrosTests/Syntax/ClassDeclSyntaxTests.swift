//
//  ClassDeclSyntaxTests.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 21/11/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

@testable import PrincipleMacros
import Testing

internal struct ClassDeclSyntaxTests {

    @Test
    func withoutInheritenceClause() throws {
        let decl: DeclSyntax = "class MyClass {}"
        let classDecl = try #require(decl.as(ClassDeclSyntax.self))
        let result = classDecl.inferredSuperclass()
        #expect(result == nil)
    }

    @Test
    func withProtocolConformance() throws {
        let decl: DeclSyntax = "class MyClass: Equatable, Hashable {}"
        let classDecl = try #require(decl.as(ClassDeclSyntax.self))
        let result = classDecl.inferredSuperclass()
        #expect(result == nil)
    }

    // swiftlint:disable empty_line_after_type_declaration

    @Test
    func withOverrideModifier() throws {
        let decl: DeclSyntax = """
        class MyClass: BaseClass<Int>, Hashable {
            override func test() {}
        }
        """

        let classDecl = try #require(decl.as(ClassDeclSyntax.self))
        let result = classDecl.inferredSuperclass()
        #expect(result?.description == "BaseClass<Int>")
    }

    @Test
    func withSuperExpression() throws {
        let decl: DeclSyntax = """
        class MyClass: BaseClass, Hashable {
            init(value: Int) {
                super.init()
            }
        }
        """

        let classDecl = try #require(decl.as(ClassDeclSyntax.self))
        let result = classDecl.inferredSuperclass()
        #expect(result?.description == "BaseClass")
    }

    @Test
    func withNestedClass() throws {
        let decl: DeclSyntax = """
        class MyClass: Equatable, Hashable {
            class NestedClass: BaseClass {
                override func test() {}
            }
        }
        """

        let classDecl = try #require(decl.as(ClassDeclSyntax.self))
        let result = classDecl.inferredSuperclass()
        #expect(result == nil)
    }

    // swiftlint:enable empty_line_after_type_declaration
}
