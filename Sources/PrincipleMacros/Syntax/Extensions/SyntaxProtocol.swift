//
//  SyntaxProtocol.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 12/01/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntaxMacros

extension SyntaxProtocol {

    public var withTrailingSpace: Self {
        with(\.trailingTrivia, .space)
    }

    public var withLeadingSpace: Self {
        with(\.leadingTrivia, .space)
    }

    public var withTrailingNewline: Self {
        with(\.trailingTrivia, .newline)
    }

    public var withLeadingNewline: Self {
        with(\.leadingTrivia, .newline)
    }

    public func withTrailingNewlines(_ count: Int = 2) -> Self {
        with(\.trailingTrivia, .newlines(count))
    }

    public func withLeadingNewlines(_ count: Int = 2) -> Self {
        with(\.leadingTrivia, .newlines(count))
    }

    public func withTrivia(from other: some SyntaxProtocol) -> Self {
        with(\.leadingTrivia, other.leadingTrivia)
            .with(\.trailingTrivia, other.trailingTrivia)
    }
}
