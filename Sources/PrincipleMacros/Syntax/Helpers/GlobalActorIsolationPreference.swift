//
//  GlobalActorIsolationPreference.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 18/08/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntax

public enum GlobalActorIsolationPreference: Hashable {

    case nonisolated
    case isolated(TypeSyntax)
}
