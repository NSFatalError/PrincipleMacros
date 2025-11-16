//
//  MacroExpansionContext.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 30/03/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntaxMacros

extension MacroExpansionContext {

    public func diagnose(
        node: some SyntaxProtocol,
        errorMessage: String
    ) {
        let message = MacroExpansionErrorMessage(errorMessage)
        let diagnostic = Diagnostic(node: node, message: message)
        diagnose(diagnostic)
    }

    public func diagnose(
        node: some SyntaxProtocol,
        warningMessage: String
    ) {
        let message = MacroExpansionWarningMessage(warningMessage)
        let diagnostic = Diagnostic(node: node, message: message)
        diagnose(diagnostic)
    }
}
