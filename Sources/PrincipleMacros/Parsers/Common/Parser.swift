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
}

extension Parser {

    public static func parse(
        ifConfig: IfConfigDeclSyntax,
        in context: some MacroExpansionContext
    ) -> ResultsCollection {
        ResultsCollection(
            ifConfig.clauses.flatMap { clause in
                switch clause.elements {
                case let .decls(members):
                    parse(members: members, in: context)
                default:
                    ResultsCollection()
                }
            }
        )
    }

    public static func parse(
        members: MemberBlockItemListSyntax,
        in context: some MacroExpansionContext
    ) -> ResultsCollection {
        ResultsCollection(
            members.flatMap { member in
                if let ifConfig = member.decl.as(IfConfigDeclSyntax.self) {
                    parse(ifConfig: ifConfig, in: context)
                } else {
                    parse(declaration: member.decl, in: context)
                }
            }
        )
    }

    public static func parse(
        memberBlock: MemberBlockSyntax,
        in context: some MacroExpansionContext
    ) -> ResultsCollection {
        parse(members: memberBlock.members, in: context)
    }
}
