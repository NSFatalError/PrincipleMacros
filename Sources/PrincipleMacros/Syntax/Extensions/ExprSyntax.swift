//
//  ExprSyntax.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 12/01/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntax

extension ExprSyntax {

    public var inferredType: TypeSyntax? {
        let literal = BooleanLiteralExprSyntax(self)?.inferredType
            ?? IntegerLiteralExprSyntax(self)?.inferredType
            ?? FloatLiteralExprSyntax(self)?.inferredType
            ?? StringLiteralExprSyntax(self)?.inferredType

        if let literal {
            return literal
        }

        let special = OptionalChainingExprSyntax(self)?.inferredType
            ?? ArrayExprSyntax(self)?.inferredType
            ?? DictionaryExprSyntax(self)?.inferredType

        if let special {
            return special
        }

        return DeclReferenceExprSyntax(self)?.inferredType
            ?? FunctionCallExprSyntax(self)?.inferredType
            ?? GenericSpecializationExprSyntax(self)?.inferredType
            ?? MemberAccessExprSyntax(self)?.inferredType
    }
}

extension BooleanLiteralExprSyntax {

    public var inferredType: TypeSyntax {
        "Bool"
    }
}

extension IntegerLiteralExprSyntax {

    public var inferredType: TypeSyntax {
        "Int"
    }
}

extension FloatLiteralExprSyntax {

    public var inferredType: TypeSyntax {
        "Double"
    }
}

extension StringLiteralExprSyntax {

    public var inferredType: TypeSyntax {
        "String"
    }
}

extension OptionalChainingExprSyntax {

    public var inferredType: TypeSyntax? {
        guard let inferredType = expression.inferredType else {
            return nil
        }
        return "Optional<\(inferredType)>"
    }
}

extension ArrayExprSyntax {

    public var inferredType: TypeSyntax? {
        guard let inferredElementType else {
            return nil
        }
        return "Array<\(inferredElementType)>"
    }

    public var inferredElementType: TypeSyntax? {
        elements.first?.expression.inferredType
    }
}

extension DictionaryExprSyntax {

    public var inferredType: TypeSyntax? {
        guard let inferredKeyType, let inferredValueType else {
            return nil
        }
        return "Dictionary<\(inferredKeyType), \(inferredValueType)>"
    }

    public var inferredKeyType: TypeSyntax? {
        switch content {
        case let .elements(elements):
            elements.first?.key.inferredType
        default:
            nil
        }
    }

    public var inferredValueType: TypeSyntax? {
        switch content {
        case let .elements(elements):
            elements.first?.value.inferredType
        default:
            nil
        }
    }
}

extension FunctionCallExprSyntax {

    public var inferredType: TypeSyntax? {
        calledExpression.inferredType
    }
}

extension GenericSpecializationExprSyntax {

    public var inferredType: TypeSyntax? {
        guard let inferredType = expression.inferredType else {
            return nil
        }
        return "\(inferredType)\(genericArgumentClause.standardized)"
    }
}

extension MemberAccessExprSyntax {

    public var inferredType: TypeSyntax? {
        guard let first = base?.inferredType else {
            return nil
        }
        if let second = declName.inferredType {
            return "\(first).\(second)"
        }
        return first
    }
}

extension DeclReferenceExprSyntax {

    public var inferredType: TypeSyntax? {
        switch baseName.tokenKind {
        case let .identifier(name) where name.first?.isUppercase == true:
            TypeSyntax(IdentifierTypeSyntax(name: .identifier(name)))
        case .keyword(.self):
            "Type"
        default:
            nil
        }
    }
}
