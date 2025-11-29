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
        var elements = [IfConfigClauseSyntax]()
        var isEmpty = true

        for clause in clauses {
            if let availability = clause.availability {
                elements.append(availability)
                isEmpty = false
            } else {
                elements.append(clause.with(\.elements, .attributes([])))
            }
        }

        guard !isEmpty else {
            return nil
        }

        let clauses = IfConfigClauseListSyntax(elements)
        return with(\.clauses, clauses)
    }
}

extension IfConfigClauseSyntax {

    public var availability: Self? {
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
