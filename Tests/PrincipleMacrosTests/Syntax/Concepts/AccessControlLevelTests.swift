//
//  AccessControlLevelTests.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 01/12/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import Testing
@testable import PrincipleMacros

internal struct AccessControlLevelTests {

    @Test(
        arguments: [
            Keyword.private,
            Keyword.fileprivate,
            Keyword.internal,
            Keyword.package,
            Keyword.public,
            Keyword.open
        ]
    )
    func conversion(_ keyword: Keyword) {
        let tokenSyntax = TokenSyntax(.keyword(keyword), presence: .present)
        let level = AccessControlLevel(tokenSyntax: tokenSyntax)
        #expect(tokenSyntax.description == level?.tokenSyntax.description)
    }

    @Test
    func comparison() {
        #expect(AccessControlLevel.private < .fileprivate)
        #expect(AccessControlLevel.fileprivate < .internal)
        #expect(AccessControlLevel.internal < .package)
        #expect(AccessControlLevel.package < .public)
        #expect(AccessControlLevel.public < .open)
    }
}

extension AccessControlLevelTests {

    struct MemberInheritance {

        func makeDecl(with level: AccessControlLevel) throws -> ClassDeclSyntax {
            let decl: DeclSyntax = "\(level)class MyClass {}"
            return try #require(decl.as(ClassDeclSyntax.self))
        }

        @Test
        func privateShouldBeRemoved() throws {
            let decl = try makeDecl(with: .private)
            let inherited = AccessControlLevel.forMember(of: decl)
            #expect(inherited == nil)
        }

        @Test
        func openShouldBecomePublicByDefault() throws {
            let decl = try makeDecl(with: .open)
            let inherited = AccessControlLevel.forMember(of: decl)
            #expect(inherited == .public)
        }

        @Test(arguments: AccessControlLevel.allCases.dropFirst().dropLast())
        func othersShouldBeKept(_ level: AccessControlLevel) throws {
            let decl = try makeDecl(with: level)
            let inherited = AccessControlLevel.forMember(of: decl)
            #expect(inherited == level)
        }
    }
}

extension AccessControlLevelTests {

    struct SiblingInheritance {

        func makeDecl(with level: AccessControlLevel) throws -> VariableDeclSyntax {
            let decl: DeclSyntax = "\(level)var myVar = 123"
            return try #require(decl.as(VariableDeclSyntax.self))
        }

        @Test
        func privateShouldBecomeFileprivate() throws {
            let decl = try makeDecl(with: .private)
            let inherited = AccessControlLevel.forSibling(of: decl)
            #expect(inherited == .fileprivate)
        }

        @Test
        func openShouldBecomePublicByDefault() throws {
            let decl = try makeDecl(with: .open)
            let inherited = AccessControlLevel.forSibling(of: decl)
            #expect(inherited == .public)
        }

        @Test(arguments: AccessControlLevel.allCases.dropFirst().dropLast())
        func othersShouldBeKept(_ level: AccessControlLevel) throws {
            let decl = try makeDecl(with: level)
            let inherited = AccessControlLevel.forSibling(of: decl)
            #expect(inherited == level)
        }
    }
}

extension AccessControlLevelTests {

    struct PeerInheritance {

        func makeDecl(with level: AccessControlLevel) throws -> VariableDeclSyntax {
            let decl: DeclSyntax = "\(level)var myVar = 123"
            return try #require(decl.as(VariableDeclSyntax.self))
        }

        @Test
        func openShouldBecomePublicByDefault() throws {
            let decl = try makeDecl(with: .open)
            let inherited = AccessControlLevel.forPeer(of: decl)
            #expect(inherited == .public)
        }

        @Test(arguments: AccessControlLevel.allCases.dropLast())
        func othersShouldBeKept(_ level: AccessControlLevel) throws {
            let decl = try makeDecl(with: level)
            let inherited = AccessControlLevel.forPeer(of: decl)
            #expect(inherited == level)
        }
    }
}
