//
//  EnumCaseCallExprBuilderTests.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 05/04/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

@testable import PrincipleMacros
import Testing

internal struct EnumCaseCallExprBuilderTests {

    func makeEnumCase(from decl: DeclSyntax) throws -> EnumCase {
        let enumCaseDecl = try #require(EnumCaseDeclSyntax(decl))
        let enumElement = try #require(enumCaseDecl.elements.first)
        return EnumCase(declaration: enumCaseDecl, element: enumElement)
    }

    @Test
    func testCallWithoutAssociatedValues() throws {
        let enumCase = try makeEnumCase(from: "case first")
        let builder = EnumCaseCallExprBuilder(for: enumCase) { _ in
            Issue.record()
            return "" as ExprSyntax
        }
        #expect(builder.build().description == ".first")
    }

    @Test
    func testCallWithUnnamedAssociatedValue() throws {
        let enumCase = try makeEnumCase(from: "case second(Int)")
        let builder = EnumCaseCallExprBuilder(for: enumCase) { _ in
            "123" as ExprSyntax
        }
        #expect(builder.build().description == ".second(123)")
    }

    @Test
    func testCallWithMultipleAssociatedValues() throws {
        let enumCase = try makeEnumCase(from: "case third(arg: String, Int)")
        let builder = EnumCaseCallExprBuilder(for: enumCase) { associatedValue in
            if associatedValue.standardizedName.description == "arg" {
                "argument" as ExprSyntax
            } else {
                "123" as ExprSyntax
            }
        }
        #expect(builder.build().description == ".third(arg: argument, 123)")
    }
}
