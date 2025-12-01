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
        declarationGroup: some DeclGroupSyntax
    ) throws -> ResultsCollection {
        let members = declarationGroup.memberBlock.members.flattened
        return try parse(members: members)
    }

    public static func parse(
        members: some Sequence<MemberBlockItemSyntax>
    ) throws -> ResultsCollection {
        try ResultsCollection(
            members.flatMap { member in
                try parse(declaration: member.decl)
            }
        )
    }
}
