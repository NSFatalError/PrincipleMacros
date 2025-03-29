//
//  DiagnosticContextMock.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 18/01/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

@testable import PrincipleMacros
import Testing

internal final class DiagnosticContextMock: DiagnosticContext {

    func diagnose(
        node: some SyntaxProtocol,
        errorMessage: String
    ) {
        Issue.record(
            "Unexpected error for \(node): \(errorMessage)"
        )
    }
}
