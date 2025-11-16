//
//  GlobalActorIsolationTests.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 14/11/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

@testable import PrincipleMacros
import Testing

internal enum GlobalActorIsolationTests {

    internal struct Function {

        @Test
        func withNonisolatedNonsendingModifier() throws {
            let decl: DeclSyntax = "nonisolated(nonsending) func test() {}"
            let functionDecl = try #require(decl.as(FunctionDeclSyntax.self))
            let isolation = GlobalActorIsolation.resolved(for: functionDecl, in: [])
            #expect(isolation?.trimmedNonisolatedModifier?.trimmedDescription == "nonisolated(nonsending)")
        }
    }

    internal struct Property {

        @Test
        func withGlobalActor() throws {
            let decl: DeclSyntax = "@MainActor var test = 123"
            let propertyDecl = try #require(decl.as(VariableDeclSyntax.self))
            let isolation = GlobalActorIsolation.resolved(for: propertyDecl, in: [])
            #expect(isolation?.standardizedIsolationType?.trimmedDescription == "MainActor")
        }

        @Test
        func withoutGlobalActor() throws {
            let decl: DeclSyntax = "var test = 123"
            let propertyDecl = try #require(decl.as(VariableDeclSyntax.self))
            let isolation = GlobalActorIsolation.resolved(for: propertyDecl, in: [])
            #expect(isolation == nil)
        }

        @Test
        func withNonisolatedModifier() throws {
            let decl: DeclSyntax = "nonisolated var test = 123"
            let propertyDecl = try #require(decl.as(VariableDeclSyntax.self))
            let isolation = GlobalActorIsolation.resolved(for: propertyDecl, in: [])
            #expect(isolation?.trimmedNonisolatedModifier?.trimmedDescription == "nonisolated")
        }

        @Test
        func withoutGlobalActorInStructWithGlobalActor() throws {
            let decl: DeclSyntax = "var test = 123"
            let propertyDecl = try #require(decl.as(VariableDeclSyntax.self))
            let structDecl: DeclSyntax = "@MainActor struct MyStruct {}"
            let lexicalContext = [Syntax(structDecl)]
            let isolation = GlobalActorIsolation.resolved(for: propertyDecl, in: lexicalContext)
            #expect(isolation?.standardizedIsolationType?.trimmedDescription == "MainActor")
        }

        @Test
        func withGlobalActorInStructWithGlobalActor() throws {
            let decl: DeclSyntax = "@MainActor var test = 123"
            let propertyDecl = try #require(decl.as(VariableDeclSyntax.self))
            let structDecl: DeclSyntax = "@MyActor struct MyStruct {}"
            let lexicalContext = [Syntax(structDecl)]
            let isolation = GlobalActorIsolation.resolved(for: propertyDecl, in: lexicalContext)
            #expect(isolation?.standardizedIsolationType?.trimmedDescription == "MainActor")
        }

        @Test
        func withNonisolatedModifierInStructWithGlobalActor() throws {
            let decl: DeclSyntax = "nonisolated var test = 123"
            let propertyDecl = try #require(decl.as(VariableDeclSyntax.self))
            let structDecl: DeclSyntax = "@MyActor struct MyStruct {}"
            let lexicalContext = [Syntax(structDecl)]
            let isolation = GlobalActorIsolation.resolved(for: propertyDecl, in: lexicalContext)
            #expect(isolation?.trimmedNonisolatedModifier?.trimmedDescription == "nonisolated")
        }

        @Test
        func inNestedStructWithGlobalActor() throws {
            let decl: DeclSyntax = "var test = 123"
            let propertyDecl = try #require(decl.as(VariableDeclSyntax.self))
            let structDecl1: DeclSyntax = "@MainActor struct Inner {}"
            let structDecl2: DeclSyntax = "@MyActor struct Outer {}"
            let lexicalContext = [Syntax(structDecl1), Syntax(structDecl2)]
            let isolation = GlobalActorIsolation.resolved(for: propertyDecl, in: lexicalContext)
            #expect(isolation?.standardizedIsolationType?.trimmedDescription == "MainActor")
        }

        @Test
        func inNestedStructWithoutGlobalActor() throws {
            let decl: DeclSyntax = "var test = 123"
            let propertyDecl = try #require(decl.as(VariableDeclSyntax.self))
            let structDecl1: DeclSyntax = "struct Inner {}"
            let structDecl2: DeclSyntax = "@MyActor struct Outer {}"
            let lexicalContext = [Syntax(structDecl1), Syntax(structDecl2)]
            let isolation = GlobalActorIsolation.resolved(for: propertyDecl, in: lexicalContext)
            #expect(isolation == nil)
        }
    }

    internal struct Class {

        @Test
        func withGlobalActor() throws {
            let decl: DeclSyntax = "@MainActor class Model {}"
            let classDecl = try #require(decl.as(ClassDeclSyntax.self))
            let isolation = GlobalActorIsolation.resolved(for: classDecl)
            #expect(isolation?.standardizedIsolationType?.trimmedDescription == "MainActor")
        }

        @Test
        func withoutGlobalActor() throws {
            let decl: DeclSyntax = "class Model {}"
            let classDecl = try #require(decl.as(ClassDeclSyntax.self))
            let isolation = GlobalActorIsolation.resolved(for: classDecl)
            #expect(isolation == nil)
        }

        @Test
        func withoutGlobalActorInStructWithGlobalActor() throws {
            let decl: DeclSyntax = "class Model {}"
            let classDecl = try #require(decl.as(ClassDeclSyntax.self))
            let structDecl: DeclSyntax = "@MyActor struct MyStruct {}"
            let lexicalContext = [Syntax(structDecl)]
            let isolation = GlobalActorIsolation.resolved(for: classDecl, in: lexicalContext)
            #expect(isolation == nil)
        }

        @Test
        func withGlobalActorInStructWithGlobalActor() throws {
            let decl: DeclSyntax = "@MainActor class Model {}"
            let classDecl = try #require(decl.as(ClassDeclSyntax.self))
            let structDecl: DeclSyntax = "@MyActor struct MyStruct {}"
            let lexicalContext = [Syntax(structDecl)]
            let isolation = GlobalActorIsolation.resolved(for: classDecl, in: lexicalContext)
            #expect(isolation?.standardizedIsolationType?.trimmedDescription == "MainActor")
        }
    }
}
