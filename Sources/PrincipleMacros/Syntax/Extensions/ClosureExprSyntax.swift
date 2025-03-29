//
//  ClosureExprSyntax.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 03/02/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftBasicFormat
import SwiftSyntax

extension ClosureExprSyntax {

    /// [GitHub Issue](https://github.com/swiftlang/swift-syntax/issues/2126)
    ///
    public func expanded(
        nestingLevel: Int = 0,
        indentationWidth: Trivia? = nil
    ) -> ClosureExprSyntax {
        let trimmed = detached.trimmed
        let format = BasicFormat(indentationWidth: indentationWidth)
        let formatted = trimmed.formatted(using: format)
        let originalSource = formatted.description.split(separator: "\n")
        let minimumNumberOfLines = 3

        guard originalSource.count >= minimumNumberOfLines else {
            return trimmed
        }

        let firstIndentedLine = originalSource[1]
        let indentation = format.indentationWidth.description

        guard firstIndentedLine.hasPrefix(indentation) else {
            return trimmed
        }

        let fixableIndentation = firstIndentedLine
            .dropFirst(indentation.count)
            .prefix(while: \.isWhitespace)
        let missingIndentation = String(
            repeating: indentation,
            count: nestingLevel
        )

        let rewrittenSource = originalSource.reduce(into: "") { result, line in
            if !result.isEmpty {
                result += "\n" + missingIndentation
            }
            if line.hasPrefix(fixableIndentation) {
                result += line.dropFirst(fixableIndentation.count)
            } else {
                result += line
            }
        }

        let expr: ExprSyntax = "\(raw: rewrittenSource)"
        return ClosureExprSyntax(expr) ?? trimmed
    }
}

extension ExprSyntax {

    public func expanded(
        nestingLevel: Int,
        indentationWidth: Trivia? = nil
    ) -> ExprSyntax {
        guard let closure = ClosureExprSyntax(self) else {
            return self
        }

        return ExprSyntax(
            closure.expanded(
                nestingLevel: nestingLevel,
                indentationWidth: indentationWidth
            )
        )
    }
}
