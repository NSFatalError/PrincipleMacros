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

    struct NoInheritanceClause {

        private func makeDecl() throws -> ClassDeclSyntax {
            let decl: DeclSyntax = "class MyClass {}"
            return try #require(decl.as(ClassDeclSyntax.self))
        }

        @Test
        func inferredSuperclass() throws {
            let result = try makeDecl().inferredSuperclass()
            #expect(result == nil)
        }
    }

    struct InheritanceClause {

        private func makeDecl() throws -> ClassDeclSyntax {
            let decl: DeclSyntax = "class MyClass: Equatable, Hashable {}"
            return try #require(decl.as(ClassDeclSyntax.self))
        }

        @Test
        func inferredSuperclass() throws {
            let result = try makeDecl().inferredSuperclass()
            #expect(result == nil)
        }
    }

    struct OverrideModifier {

        private func makeDecl() throws -> ClassDeclSyntax {
            let decl: DeclSyntax = """
            class MyClass: BaseClass<Int>, Hashable {
                override func test() {}
            }
            """
            return try #require(decl.as(ClassDeclSyntax.self))
        }

        @Test
        func inferredSuperclass() throws {
            let result = try makeDecl().inferredSuperclass()
            #expect(result?.description == "BaseClass<Int>")
        }
    }

    struct SuperExpr {

        private func makeDecl() throws -> ClassDeclSyntax {
            let decl: DeclSyntax = """
            class MyClass: BaseClass, Hashable {
                init(value: Int) {
                    super.init()
                }
            }
            """
            return try #require(decl.as(ClassDeclSyntax.self))
        }

        @Test
        func inferredSuperclass() throws {
            let result = try makeDecl().inferredSuperclass()
            #expect(result?.description == "BaseClass")
        }
    }

    struct NestedClassDecl {

        private func makeDecl() throws -> ClassDeclSyntax {
            let decl: DeclSyntax = """
            class MyClass: Equatable, Hashable {
                class NestedClass: BaseClass {
                    override func test() {}
                }
            }
            """
            return try #require(decl.as(ClassDeclSyntax.self))
        }

        @Test
        func inferredSuperclass() throws {
            let result = try makeDecl().inferredSuperclass()
            #expect(result == nil)
        }
    }
}
