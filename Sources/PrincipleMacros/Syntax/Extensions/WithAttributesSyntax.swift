//
//  WithAttributesSyntax.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 17/01/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntaxMacros

extension WithAttributesSyntax {

    public var globalActorIsolation: GlobalActorIsolation? {
        let attribute = attributes.attributeElements.first { attribute in
            attribute.attributeName.trimmedDescription.hasSuffix("Actor")
        }
        if let attribute {
            let standardizedType = attribute.attributeName.standardized
            return .isolated(standardizedType: standardizedType)
        }
        return nil
    }
}
