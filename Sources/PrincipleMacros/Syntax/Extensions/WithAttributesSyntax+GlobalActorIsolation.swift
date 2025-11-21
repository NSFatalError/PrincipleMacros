//
//  WithAttributesSyntax+GlobalActorIsolation.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 17/01/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntaxMacros

extension WithAttributesSyntax {

    public var globalActorIsolation: GlobalActorIsolation? {
        attributes.lazy
            .compactMap(\.attribute?.globalActorIsolation)
            .first
    }
}

extension AttributeSyntax {

    public var globalActorIsolation: GlobalActorIsolation? {
        if attributeName.trimmedDescription.hasSuffix("Actor") {
            let standardizedType = attributeName.standardized
            return .isolated(standardizedType: standardizedType)
        }
        return nil
    }
}

extension AttributeListSyntax.Element {

    public var attribute: AttributeSyntax? {
        switch self {
        case let .attribute(attribute):
            attribute
        case .ifConfigDecl:
            nil
        }
    }
}
