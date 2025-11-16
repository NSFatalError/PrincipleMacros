//
//  PeerBuilding.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 13/11/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

public protocol PeerBuilding {}

extension PeerBuilding where Self: DeclBuilder {

    public var inheritedAccessControlLevel: AccessControlLevel? {
        .forPeer(
            of: basicDeclaration,
            preferred: preferredAccessControlLevel,
            maxAllowed: maxAllowedAccessControlLevel
        )
    }
}
