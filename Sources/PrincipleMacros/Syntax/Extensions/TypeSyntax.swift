//
//  TypeSyntax.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 14/01/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntax

extension TypeSyntax {

    public func isLike(_ other: TypeSyntax) -> Bool {
        trimmedDescription == other.trimmedDescription
    }
}

extension TypeSyntax {

    public var standardized: TypeSyntax {
        let special = OptionalTypeSyntax(self)?.standardized
            ?? ImplicitlyUnwrappedOptionalTypeSyntax(self)?.standardized
            ?? ArrayTypeSyntax(self)?.standardized
            ?? DictionaryTypeSyntax(self)?.standardized

        if let special {
            return special
        }

        return IdentifierTypeSyntax(self)?.standardized
            ?? MemberTypeSyntax(self)?.standardized
            ?? TupleTypeSyntax(self)?.standardized
            ?? trimmed
    }
}

extension OptionalTypeSyntax {

    public var standardized: TypeSyntax {
        "Optional<\(wrappedType.standardized)>"
    }
}

extension ImplicitlyUnwrappedOptionalTypeSyntax {

    public var standardized: TypeSyntax {
        "Optional<\(wrappedType.standardized)>"
    }
}

extension ArrayTypeSyntax {

    public var standardized: TypeSyntax {
        "Array<\(element.standardized)>"
    }
}

extension DictionaryTypeSyntax {

    public var standardized: TypeSyntax {
        "Dictionary<\(key.standardized), \(value.standardized)>"
    }
}

extension IdentifierTypeSyntax {

    public var standardized: TypeSyntax {
        if let genericArgumentClause {
            "\(name.trimmed)\(genericArgumentClause.standardized)"
        } else {
            "\(name.trimmed)"
        }
    }
}

extension MemberTypeSyntax {

    public var standardized: TypeSyntax {
        if let genericArgumentClause {
            "\(baseType.standardized).\(name.trimmed)\(genericArgumentClause.standardized)"
        } else {
            "\(baseType.standardized).\(name.trimmed)"
        }
    }
}

extension TupleTypeSyntax {

    public var standardized: TypeSyntax {
        guard !elements.isEmpty else {
            return "Void"
        }
        return TypeSyntax(
            TupleTypeSyntax(
                elements: TupleTypeElementListSyntax(
                    elements.map { element in
                        TupleTypeElementSyntax(
                            firstName: element.firstName?.trimmed,
                            secondName: element.secondName?.trimmed.withLeadingSpace,
                            colon: element.colon?.trimmed.withTrailingSpace,
                            type: element.type.standardized,
                            trailingComma: element.trailingComma?.trimmed.withTrailingSpace
                        )
                    }
                )
            )
        )
    }
}

extension GenericArgumentClauseSyntax {

    public var standardized: GenericArgumentClauseSyntax {
        GenericArgumentClauseSyntax(
            arguments: GenericArgumentListSyntax(
                arguments.map { element in
                    #if canImport(SwiftSyntax601)
                        switch element.argument {
                        case let .type(type):
                            GenericArgumentSyntax(
                                argument: .type(type.standardized),
                                trailingComma: element.trailingComma?.trimmed.withTrailingSpace
                            )
                        default:
                            GenericArgumentSyntax(
                                argument: element.argument,
                                trailingComma: element.trailingComma?.trimmed.withTrailingSpace
                            )
                        }
                    #else
                        GenericArgumentSyntax(
                            argument: element.argument.standardized,
                            trailingComma: element.trailingComma?.trimmed.withTrailingSpace
                        )
                    #endif
                }
            )
        )
    }
}

extension ThrowsClauseSyntax {

    public var standardized: ThrowsClauseSyntax {
        ThrowsClauseSyntax(
            throwsSpecifier: .keyword(.throws),
            leftParen: leftParen?.trimmed,
            type: type?.standardized,
            rightParen: rightParen?.trimmed
        )
    }
}
