//
//  GlobalActorIsolation.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 18/08/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntax

public struct GlobalActorIsolation: Hashable {

    public let trimmedType: TypeSyntax

    public var trimmedAttribute: AttributeSyntax {
        AttributeSyntax(attributeName: trimmedType)
    }

    public var inlinableAttribute: AttributeSyntax {
        trimmedAttribute.withTrailingSpace
    }
}
