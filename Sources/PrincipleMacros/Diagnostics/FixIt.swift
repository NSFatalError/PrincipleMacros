//
//  FixIt.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 30/11/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntaxMacros

extension FixIt {

    public static func remove(
        message: String,
        oldNode: some SyntaxProtocol
    ) -> Self {
        .replace(
            message: MacroExpansionFixItMessage(message),
            oldNode: oldNode,
            newNode: "\(oldNode.leadingTrivia)" as TokenSyntax
        )
    }

    public static func replace(
        message: String,
        oldNode: some SyntaxProtocol,
        newNode: some SyntaxProtocol
    ) -> Self {
        .replace(
            message: MacroExpansionFixItMessage(message),
            oldNode: oldNode,
            newNode: newNode.withTrivia(from: oldNode)
        )
    }
}
