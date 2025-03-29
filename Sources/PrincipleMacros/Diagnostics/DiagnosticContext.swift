//
//  DiagnosticContext.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 12/01/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntax

public protocol DiagnosticContext {

    func diagnose(
        node: some SyntaxProtocol,
        errorMessage: String
    )
}
