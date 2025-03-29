//
//  SwiftSyntaxDiagnosticContext.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 17/01/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftDiagnostics
import SwiftSyntaxMacros

public struct SwiftSyntaxDiagnosticContext<Context: MacroExpansionContext> {

    private let context: Context

    public init(_ context: Context) {
        self.context = context
    }
}

extension SwiftSyntaxDiagnosticContext: DiagnosticContext {

    public func diagnose(
        node: some SyntaxProtocol,
        errorMessage: String
    ) {
        context.diagnose(
            Diagnostic(
                node: node,
                message: MacroExpansionErrorMessage(errorMessage)
            )
        )
    }
}
