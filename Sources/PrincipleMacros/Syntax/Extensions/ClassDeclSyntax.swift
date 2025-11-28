//
//  ClassDeclSyntax.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 21/11/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntaxMacros

extension ClassDeclSyntax {

    public var unverifiedInferredSuperclassType: TypeSyntax? {
        inheritanceClause?.inheritedTypes.first?.type.trimmed
    }

    public func inferredSuperclassType() -> TypeSyntax? {
        let verifier = SuperclassVerifier(for: self)
        return verifier.verifiedSuperclassType()
    }

    public func inferredSuperclassType(
        isExpected: Bool?
    ) throws -> TypeSyntax? {
        switch isExpected {
        case nil:
            return inferredSuperclassType()
        case true:
            if let type = unverifiedInferredSuperclassType {
                return type
            }
            throw DiagnosticsError(
                node: self,
                message: "\(name.trimmed) should have a superclass"
            )
        case false:
            return nil
        }
    }
}

extension ClassDeclSyntax {

    private final class SuperclassVerifier: SyntaxVisitor {

        private let classDecl: ClassDeclSyntax
        private var didVerify = false

        init(for classDecl: ClassDeclSyntax) {
            self.classDecl = classDecl
            super.init(viewMode: .sourceAccurate)
        }

        func verifiedSuperclassType() -> TypeSyntax? {
            if let unverified = classDecl.unverifiedInferredSuperclassType {
                walk(classDecl)
                return didVerify ? unverified : nil
            } else {
                return nil
            }
        }

        override func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
            node == classDecl ? .visitChildren : .skipChildren
        }

        override func visit(_ node: DeclModifierSyntax) -> SyntaxVisitorContinueKind {
            didVerify = didVerify || node.overrideSpecifier != nil
            return .visitChildren
        }

        override func visit(_: SuperExprSyntax) -> SyntaxVisitorContinueKind {
            didVerify = true
            return .visitChildren
        }
    }
}
