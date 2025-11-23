//
//  ClassDeclSyntax.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 21/11/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntaxMacros

extension ClassDeclSyntax {

    public var unverifiedInferredSuperclass: TypeSyntax? {
        inheritanceClause?.inheritedTypes.first?.type.trimmed
    }

    public func inferredSuperclass() -> TypeSyntax? {
        let visitor = SubclassKeywordsVisitor(for: self)
        return visitor.verifiedSuperclass()
    }
}

extension ClassDeclSyntax {

    private final class SubclassKeywordsVisitor: SyntaxVisitor {

        private let classDecl: ClassDeclSyntax
        private var didVerify = false

        init(for classDecl: ClassDeclSyntax) {
            self.classDecl = classDecl
            super.init(viewMode: .sourceAccurate)
        }

        func verifiedSuperclass() -> TypeSyntax? {
            guard let unverified = classDecl.unverifiedInferredSuperclass else {
                return nil
            }

            walk(classDecl)
            return didVerify ? unverified : nil
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
