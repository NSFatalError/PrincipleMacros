//
//  SwitchExprBuilderTests.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 05/04/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

@testable import PrincipleMacros
import Testing

internal struct SwitchExprBuilderTests {

    func makeEnumCase(from decl: DeclSyntax) throws -> EnumCase {
        let enumCaseDecl = try #require(EnumCaseDeclSyntax(decl))
        let enumElement = try #require(enumCaseDecl.elements.first)
        return EnumCase(declaration: enumCaseDecl, element: enumElement)
    }

    @Test
    func testSwitchExpression() throws {
        let enumCases = try EnumCasesList([
            makeEnumCase(from: "case first"),
            makeEnumCase(from: "case second(Int)"),
            makeEnumCase(from: "case third(arg: String, Int)")
        ])

        let builder = SwitchExprBuilder(for: enumCases, over: "subject") { enumCase in
            "return \(raw: enumCase.associatedValues.count)"
        }

        let expectation = """
        switch subject {
        case .first:
            return 0
        case let .second(_0):
            return 1
        case let .third(arg, _1):
            return 2
        }
        """

        #expect(builder.build().description == expectation)
    }
}
