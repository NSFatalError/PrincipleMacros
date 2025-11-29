//
//  MemberBuilding.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 13/11/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

public protocol MemberBuilding {}

extension MemberBuilding where Self: TypeDeclBuilder {

    public var inheritedAccessControlLevel: AccessControlLevel? {
        .forMember(
            of: typeDeclaration,
            preferred: preferredAccessControlLevel
        )
    }

    public var inheritedAccessControlLevelAllowingOpen: AccessControlLevel? {
        .forMember(
            of: typeDeclaration,
            preferred: preferredAccessControlLevel,
            maxAllowed: .open
        )
    }
}
