//
//  AccessControlLevelInheritanceSettings.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 12/11/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntaxMacros

public struct AccessControlLevelInheritanceSettings: Hashable {

    public var inheritingDeclaration: InheritingDeclaration
    public var maxAllowed: Keyword

    public init(
        inheritingDeclaration: InheritingDeclaration,
        maxAllowed: Keyword = .public
    ) {
        self.inheritingDeclaration = inheritingDeclaration
        self.maxAllowed = maxAllowed
    }
}

extension AccessControlLevelInheritanceSettings {

    public enum InheritingDeclaration: Hashable {

        case member
        case peer
    }
}
