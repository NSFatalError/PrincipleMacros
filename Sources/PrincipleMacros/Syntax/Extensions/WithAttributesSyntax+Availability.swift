//
//  WithAttributesSyntax.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 17/01/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntaxMacros

extension WithAttributesSyntax {

    var availability: AttributeListSyntax? {
        let availability = attributes.compactMap(\.availability)
        return availability.isEmpty ? nil : AttributeListSyntax(availability)
    }
}

extension AttributeListSyntax {

    var availability: Self? {
        let elements = compactMap(\.availability)
        return elements.isEmpty ? nil : AttributeListSyntax(elements)
    }
}

extension AttributeListSyntax.Element {

    var availability: Self? {
        switch self {
        case .attribute(let attribute):
            if let availability = attribute.availability {
                return .attribute(availability)
            }
        case .ifConfigDecl(let ifConfig):
            if let availability = ifConfig.availability {
                return .ifConfigDecl(availability)
            }
        }
        return nil
    }
}

extension AttributeSyntax {

    public var availability: Self? {
        arguments?.is(AvailabilityArgumentListSyntax.self) == true ? self : nil
    }
}
