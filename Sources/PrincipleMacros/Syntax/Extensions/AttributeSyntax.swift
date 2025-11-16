//
//  AttributeSyntax.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 15/11/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntaxMacros

extension AttributeSyntax {

    public func isLike(_ other: AttributeSyntax) -> Bool {
        attributeName.isLike(other.attributeName)
    }
}
