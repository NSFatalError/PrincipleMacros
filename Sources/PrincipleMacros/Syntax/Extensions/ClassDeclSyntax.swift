//
//  ClassDeclSyntax.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 21/11/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntaxMacros

extension ClassDeclSyntax {

    public func inferredSuperclass() -> TypeSyntax? {
        let superclassFinder = SuperclassFinder(for: self)
        return superclassFinder.find()?.trimmed
    }
}

extension ClassDeclSyntax {

    private final class SuperclassFinder: SyntaxVisitor {

        private let classDecl: ClassDeclSyntax
        private var didVerify = false

        init(for classDecl: ClassDeclSyntax) {
            self.classDecl = classDecl
            super.init(viewMode: .sourceAccurate)
        }

        func find() -> TypeSyntax? {
            guard let inheritanceClause = classDecl.inheritanceClause,
                  let firstInheritedType = inheritanceClause.inheritedTypes.first?.type
            else {
                return nil
            }

            walk(classDecl)
            return didVerify ? firstInheritedType : nil
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
