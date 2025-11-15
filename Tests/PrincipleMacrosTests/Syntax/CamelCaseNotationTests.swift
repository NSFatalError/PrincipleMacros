//
//  CamelCaseNotationTests.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 14/11/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

@testable import PrincipleMacros
import Testing

internal struct CamelCaseNotationTests {

    @Test(
        arguments: [
            ("", []),
            ("x", ["x"]),
            ("X", ["X"]),
            ("URL", ["URL"]),
            ("name", ["name"]),
            ("Name", ["Name"]),
            ("longName", ["long", "Name"]),
            ("LongName", ["Long", "Name"]),
            ("VERYLongName", ["VERY", "Long", "Name"]),
            ("VeryLONGName", ["Very", "LONG", "Name"]),
            ("veryLongNAME", ["very", "Long", "NAME"])
        ]
    )
    func segments(from string: String, expectation: [String]) {
        let notation = CamelCaseNotation(string: string)
        #expect(notation.segments.map(\.string) == expectation)
    }

    @Test(
        arguments: [
            ("", ""),
            ("x", "X"),
            ("X", "X"),
            ("URL", "URL"),
            ("name", "Name"),
            ("Name", "Name"),
            ("longName", "LongName"),
            ("LongName", "LongName"),
            ("VERYLongName", "VERYLongName"),
            ("VeryLONGName", "VeryLONGName"),
            ("veryLongNAME", "VeryLongNAME")
        ]
    )
    func upperCamelCase(from string: String, expectation: String) {
        let notation = CamelCaseNotation(string: string)
        #expect(notation.joined(as: .upperCamelCase) == expectation)
    }

    @Test(
        arguments: [
            ("", ""),
            ("x", "x"),
            ("X", "x"),
            ("URL", "url"),
            ("name", "name"),
            ("Name", "name"),
            ("longName", "longName"),
            ("LongName", "longName"),
            ("VERYLongName", "veryLongName"),
            ("VeryLONGName", "veryLONGName"),
            ("veryLongNAME", "veryLongNAME")
        ]
    )
    func lowerCamelCase(from string: String, expectation: String) {
        let notation = CamelCaseNotation(string: string)
        #expect(notation.joined(as: .lowerCamelCase) == expectation)
    }
}
