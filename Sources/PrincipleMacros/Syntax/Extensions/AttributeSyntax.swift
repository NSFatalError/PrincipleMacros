//
//  AttributeSyntax.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 14/11/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntaxMacros

extension AttributeListSyntax {

    public var attributeElements: some Collection<AttributeSyntax> {
        lazy.compactMap { element in
            switch element {
            case let .attribute(attribute):
                attribute
            default:
                nil
            }
        }
    }

    public func contains(likeOneOf someAttributes: AttributeSyntax...) -> Bool {
        attributeElements.contains { attribute in
            someAttributes.contains { attribute.isLike($0) }
        }
    }

    public func contains(like someAttribute: AttributeSyntax) -> Bool {
        contains(likeOneOf: someAttribute)
    }
}

extension AttributeSyntax {

    public func isLike(_ other: AttributeSyntax) -> Bool {
        attributeName.isLike(other.attributeName)
    }
}
