//
//  IfConfigDeclSyntax+EnclosingIfConfig.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 21/11/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntax

extension IfConfigDeclSyntax {

    fileprivate var aligned: Self {
        with(\.poundEndif, .poundEndifToken(leadingTrivia: .newline))
    }

    public var enclosingIfConfig: IfConfigDeclSyntax? {
        if let parent = aligned.parent?.as(MemberBlockItemSyntax.self) {
            return parent.enclosingIfConfig
        }
        return nil
    }
}

extension IfConfigClauseListSyntax {

    public var enclosingIfConfig: IfConfigDeclSyntax? {
        if let parent = parent?.as(IfConfigDeclSyntax.self) {
            return parent.enclosingIfConfig ?? parent.aligned
        }
        return nil
    }
}

extension IfConfigClauseSyntax {

    private var aligned: Self {
        with(\.poundKeyword, poundKeyword.trimmed.withTrailingSpace)
    }

    public var enclosingIfConfig: IfConfigDeclSyntax? {
        guard var parent = parent?.as(IfConfigClauseListSyntax.self) else {
            return nil
        }

        for (index, clause) in zip(parent.indices, parent) {
            parent[index] = if clause == self {
                aligned
            } else {
                clause.aligned
                    .with(\.elements, .decls([]))
                    .withTrailingNewline
            }
        }

        return parent.enclosingIfConfig
    }
}

extension MemberBlockItemListSyntax {

    public var enclosingIfConfig: IfConfigDeclSyntax? {
        if let parent = parent?.as(IfConfigClauseSyntax.self) {
            return parent.enclosingIfConfig
        }
        return nil
    }
}

extension MemberBlockItemSyntax {

    public var enclosingIfConfig: IfConfigDeclSyntax? {
        guard var parent = parent?.as(MemberBlockItemListSyntax.self) else {
            return nil
        }

        parent.replaceSubrange(
            parent.startIndex ..< parent.endIndex,
            with: CollectionOfOne(trimmed.withLeadingNewline)
        )

        return parent.enclosingIfConfig
    }
}

extension DeclSyntaxProtocol {

    public var enclosingIfConfig: IfConfigDeclSyntax? {
        if let parent = parent?.as(MemberBlockItemSyntax.self) {
            return parent.enclosingIfConfig
        }
        return nil
    }

    public func applyingEnclosingIfConfig(
        to members: MemberBlockItemListSyntax
    ) -> IfConfigDeclSyntax? {
        guard var parent = parent?.parent?.as(MemberBlockItemListSyntax.self) else {
            return nil
        }

        parent.replaceSubrange(
            parent.startIndex ..< parent.endIndex,
            with: members
        )

        return parent.withLeadingNewline.enclosingIfConfig
    }
}
