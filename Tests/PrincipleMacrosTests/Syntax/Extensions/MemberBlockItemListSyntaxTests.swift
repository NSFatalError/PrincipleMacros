//
//  MemberBlockItemListSyntaxTests.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 01/12/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

@testable import PrincipleMacros
import Testing

internal enum MemberBlockItemListSyntaxTests {

    struct Flattening {

        @Test
        func members() {
            let members: MemberBlockItemListSyntax = """
            let a = ""
            var b = 123
            func c() {}
            """

            let flattened = members.flattened
            #expect(members.elementsEqual(flattened))
        }

        @Test
        func ifConfig() {
            let members: MemberBlockItemListSyntax = """
            let a = ""
            #if os(macOS)
            var b = 123
            #else
            func c() {}
            #endif
            func d() {}
            """

            let flattened = Array(members.flattened)
            #expect(flattened.count == 4)
        }

        @Test
        func nestedIfConfig() {
            let members: MemberBlockItemListSyntax = """
            let a = ""
            #if os(macOS)
            var b = 123
            #else
                #if os(iOS)
                func c() {}
                #else
                func d() {}
                #endif
            #endif
            func e() {}
            """

            let flattened = Array(members.flattened)
            #expect(flattened.count == 5)
        }
    }
}
