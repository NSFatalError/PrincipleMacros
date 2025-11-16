//
//  AttributeListSyntax.swift
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

    public func first(like other: AttributeSyntax) -> AttributeSyntax? {
        attributeElements.first { $0.isLike(other) }
    }

    public func contains(like other: AttributeSyntax) -> Bool {
        first(like: other) != nil
    }

    public func contains(likeOneOf other: AttributeSyntax...) -> Bool {
        attributeElements.contains { attribute in
            other.contains { attribute.isLike($0) }
        }
    }
}
