//
//  IfConfigDeclSyntax+EnclosingIfConfig.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 21/11/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntax

extension IfConfigDeclSyntax {

    var enclosingIfConfig: IfConfigDeclSyntax? {
        if let parent = parent?.as(MemberBlockItemSyntax.self) {
            return parent.enclosingIfConfig
        }
        return nil
    }
}

extension IfConfigClauseListSyntax {

    var enclosingIfConfig: IfConfigDeclSyntax? {
        if let parent = parent?.as(IfConfigDeclSyntax.self) {
            return parent.enclosingIfConfig ?? parent
        }
        return nil
    }
}

extension IfConfigClauseSyntax {

    var enclosingIfConfig: IfConfigDeclSyntax? {
        if let parent = parent?.as(IfConfigClauseListSyntax.self) {
            return parent.enclosingIfConfig
        }
        return nil
    }
}

extension MemberBlockItemListSyntax {

    var enclosingIfConfig: IfConfigDeclSyntax? {
        if let parent = parent?.as(IfConfigClauseSyntax.self) {
            return parent.enclosingIfConfig
        }
        return nil
    }
}

extension MemberBlockItemSyntax {

    var enclosingIfConfig: IfConfigDeclSyntax? {
        if let parent = parent?.as(MemberBlockItemListSyntax.self) {
            return parent.enclosingIfConfig
        }
        return nil
    }
}

extension DeclSyntaxProtocol {

    var enclosingIfConfig: IfConfigDeclSyntax? {
        if let parent = parent?.as(MemberBlockItemSyntax.self) {
            return parent.enclosingIfConfig
        }
        return nil
    }
}
