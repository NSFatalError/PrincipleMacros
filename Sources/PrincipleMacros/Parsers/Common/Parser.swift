//
//  Parser.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 22/01/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntaxMacros

public protocol Parser {

    associatedtype ResultsCollection: ParserResultsCollection

    static func parse(
        declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) -> ResultsCollection

    static func parse(
        memberBlock: MemberBlockSyntax,
        in context: some MacroExpansionContext
    ) -> ResultsCollection
}

extension Parser {

    public static func parse(
        memberBlock: MemberBlockSyntax,
        in context: some MacroExpansionContext
    ) -> ResultsCollection {
        ResultsCollection(
            memberBlock.members.flatMap { member in
                parse(declaration: member.decl, in: context)
            }
        )
    }
}
