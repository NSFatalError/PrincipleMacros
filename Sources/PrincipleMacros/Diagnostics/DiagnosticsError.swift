//
//  DiagnosticsError.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 21/11/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntaxMacros

extension DiagnosticsError {

    public init(
        node: some SyntaxProtocol,
        message: String
    ) {
        let message = MacroExpansionErrorMessage(message)
        let diagnostic = Diagnostic(node: node, message: message)
        self.init(diagnostics: [diagnostic])
    }
}
