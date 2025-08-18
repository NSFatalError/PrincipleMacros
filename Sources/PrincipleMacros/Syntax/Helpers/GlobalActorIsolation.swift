//
//  GlobalActorIsolation.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 18/08/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntax

public enum GlobalActorIsolation: Hashable {

    case nonisolated
    case isolated(trimmedType: TypeSyntax)

    public var trimmedType: TypeSyntax? {
        switch self {
        case let .isolated(type):
            type
        case .nonisolated:
            nil
        }
    }

    public var trimmedAttribute: AttributeSyntax? {
        guard let trimmedType else {
            return nil
        }
        return AttributeSyntax(
            attributeName: trimmedType
        )
    }
}
