//
//  MemberBlockItemListSyntax.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 30/11/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntaxMacros

extension MemberBlockItemListSyntax {

    public var flattened: some Sequence<MemberBlockItemSyntax> {
        lazy.flatMap { member in
            if let ifConfig = member.decl.as(IfConfigDeclSyntax.self) {
                AnySequence(ifConfig.flattenedMembers)
            } else {
                AnySequence(CollectionOfOne(member))
            }
        }
    }
}

extension IfConfigDeclSyntax {

    public var flattenedMembers: some Sequence<MemberBlockItemSyntax> {
        clauses.lazy.flatMap(\.flattenedMembers)
    }
}

extension IfConfigClauseSyntax {

    public var flattenedMembers: some Sequence<MemberBlockItemSyntax> {
        switch elements {
        case let .decls(members):
            AnySequence(members.flattened)
        default:
            AnySequence(EmptyCollection<MemberBlockItemSyntax>())
        }
    }
}
