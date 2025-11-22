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
        declaration: some DeclSyntaxProtocol
    ) throws -> ResultsCollection
}

extension Parser {

    public static func parse(
        ifConfig: IfConfigDeclSyntax
    ) throws -> ResultsCollection {
        try ResultsCollection(
            ifConfig.clauses.flatMap { clause in
                switch clause.elements {
                case let .decls(members):
                    try parse(members: members)
                default:
                    ResultsCollection()
                }
            }
        )
    }

    public static func parse(
        members: MemberBlockItemListSyntax
    ) throws -> ResultsCollection {
        try ResultsCollection(
            members.flatMap { member in
                if let ifConfig = member.decl.as(IfConfigDeclSyntax.self) {
                    try parse(ifConfig: ifConfig)
                } else {
                    try parse(declaration: member.decl)
                }
            }
        )
    }

    public static func parse(
        memberBlock: MemberBlockSyntax
    ) throws -> ResultsCollection {
        try parse(members: memberBlock.members)
    }
}
