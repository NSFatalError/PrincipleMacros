//
//  ClassDeclSyntaxTests.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 21/11/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

@testable import PrincipleMacros
import Testing

internal enum ClassDeclSyntaxTests {

    struct InferredSuperclassType {

        @Test
        func withoutInheritanceClause() throws {
            let decl: DeclSyntax = "class MyClass {}"
            let classDecl = try #require(decl.as(ClassDeclSyntax.self))
            let inferredSuperclass = classDecl.inferredSuperclassType()
            #expect(inferredSuperclass == nil)
        }

        @Test
        func withProtocolConformance() throws {
            let decl: DeclSyntax = "class MyClass: Equatable, Hashable {}"
            let classDecl = try #require(decl.as(ClassDeclSyntax.self))
            let inferredSuperclass = classDecl.inferredSuperclassType()
            #expect(inferredSuperclass == nil)
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
            let inferredSuperclass = classDecl.inferredSuperclassType()
            #expect(inferredSuperclass?.description == "BaseClass<Int>")
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
            let inferredSuperclass = classDecl.inferredSuperclassType()
            #expect(inferredSuperclass?.description == "BaseClass")
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
            let inferredSuperclass = classDecl.inferredSuperclassType()
            #expect(inferredSuperclass == nil)
        }

        // swiftlint:enable empty_line_after_type_declaration
    }
}
