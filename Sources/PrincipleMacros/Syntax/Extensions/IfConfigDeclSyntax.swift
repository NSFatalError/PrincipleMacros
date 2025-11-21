//
//  IfConfigDeclSyntax.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 21/11/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntaxMacros

extension IfConfigDeclSyntax {

    var availability: Self? {
        var elements = clauses.compactMap(\.availability)
        guard let first = elements.first else {
            return nil
        }

        elements[0] = first.detached.with(\.poundKeyword, .poundIfToken())
        return with(\.clauses, IfConfigClauseListSyntax(elements))
    }
}

extension IfConfigClauseSyntax {

    var availability: Self? {
        if let availability = elements?.availability {
            return with(\.elements, availability)
        } else {
            return nil
        }
    }
}

extension IfConfigClauseSyntax.Elements {

    var availability: Self? {
        switch self {
        case .attributes(let attributes):
            if let availability = attributes.availability {
                return .attributes(availability)
            }
        default:
            break
        }
        return nil
    }
}
