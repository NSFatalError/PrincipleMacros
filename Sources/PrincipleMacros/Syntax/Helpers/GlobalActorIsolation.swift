//
//  GlobalActorIsolationPreference.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 18/08/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntax

public enum GlobalActorIsolation: Hashable {

    case nonisolated
    case isolated(TypeSyntax)

    public var type: TypeSyntax? {
        switch self {
        case .isolated(let type):
            type
        case .nonisolated:
            nil
        }
    }

    public var attribute: AttributeSyntax? {
        guard let type else {
            return nil
        }
        return AttributeSyntax(attributeName: type)
    }
}
