//
//  ExplicitGlobalActorIsolation.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 12/11/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

public enum ExplicitGlobalActorIsolation: Hashable {

    case nonisolated
    case isolated(GlobalActorIsolation)

    public var underlying: GlobalActorIsolation? {
        switch self {
        case let .isolated(isolation):
            isolation
        case .nonisolated:
            nil
        }
    }
}
