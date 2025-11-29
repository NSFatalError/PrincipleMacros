//
//  AvailabilityTests.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 22/11/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

@testable import PrincipleMacros
import Testing

internal struct AvailabilityTests {

    @Test
    func withoutAvailability() throws {
        let decl: DeclSyntax = """
        @MainActor @Observable
        class MyClass {}
        """

        let classDecl = try #require(decl.as(ClassDeclSyntax.self))
        #expect(classDecl.availability == nil)
    }

    @Test
    func withAvailability() throws {
        let decl: DeclSyntax = """
        @MainActor @Observable
        @available(iOS 26, *)
        class MyClass {}
        """

        let classDecl = try #require(decl.as(ClassDeclSyntax.self))
        #expect(classDecl.availability?.trimmedDescription == "@available(iOS 26, *)")
    }

    @Test
    func withIfConfig() throws {
        let decl: DeclSyntax = """
        #if os(macOS)
        @MainActor 
        @available(macOS 26, *)
        #else
        @Observable
        @available(iOS 26, *)
        #endif
        class MyClass {}
        """

        let expectation = """
        #if os(macOS)
        @available(macOS 26, *)
        #else
        @available(iOS 26, *)
        #endif
        """

        let classDecl = try #require(decl.as(ClassDeclSyntax.self))
        #expect(classDecl.availability?.trimmedDescription == expectation)
    }
}
