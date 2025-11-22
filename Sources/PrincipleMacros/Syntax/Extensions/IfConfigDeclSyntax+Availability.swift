//
//  IfConfigDeclSyntax+Availability.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 21/11/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntaxMacros

extension IfConfigDeclSyntax {

    public var availability: Self? {
        guard clauses.contains(where: { $0.availability != nil }) else {
            return nil
        }
        let elements = clauses.compactMap { clause in
            clause.availability ?? clause.with(\.elements, .attributes([]))
        }
        return with(\.clauses, IfConfigClauseListSyntax(elements))
    }
}

extension IfConfigClauseSyntax {

    var availability: Self? {
        if let availability = elements?.availability {
            with(\.elements, availability)
        } else {
            nil
        }
    }
}

extension IfConfigClauseSyntax.Elements {

    public var availability: Self? {
        switch self {
        case let .attributes(attributes):
            if let availability = attributes.availability {
                return .attributes(availability)
            }
        default:
            break
        }
        return nil
    }
}
