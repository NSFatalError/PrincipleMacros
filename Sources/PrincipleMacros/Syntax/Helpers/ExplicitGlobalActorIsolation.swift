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

    public var globalActor: GlobalActorIsolation? {
        switch self {
        case let .isolated(globalActor):
            globalActor
        case .nonisolated:
            nil
        }
    }
}
