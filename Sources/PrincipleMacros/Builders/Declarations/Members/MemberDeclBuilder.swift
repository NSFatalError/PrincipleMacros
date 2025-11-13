//
//  MemberDeclBuilder.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 26/01/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntaxMacros

public protocol MemberDeclBuilder: DeclBuilder {

    var lexicalContext: [Syntax] { get }
}

extension MemberDeclBuilder {

    public var inheritedGlobalActorIsolation: GlobalActorIsolation? {
        .resolved(
            for: basicDeclaration,
            in: lexicalContext,
            preferred: preferredGlobalActorIsolation
        )
    }
}
