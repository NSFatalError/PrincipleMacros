//
//  _Parser.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 22/01/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

internal protocol _Parser: Parser
where ResultsCollection: _ParserResultsCollection {}

extension _Parser {

    public static func parse(
        memberBlock: MemberBlockSyntax,
        in context: DiagnosticContext
    ) -> ResultsCollection {
        ResultsCollection(
            memberBlock.members.flatMap { member in
                parse(declaration: member.decl, in: context)
            }
        )
    }
}
