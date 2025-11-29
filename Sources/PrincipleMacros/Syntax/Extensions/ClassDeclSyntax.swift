//
//  ClassDeclSyntax.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 21/11/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntaxMacros

extension ClassDeclSyntax {

    public var possibleSuperclassType: TypeSyntax? {
        inheritanceClause?.inheritedTypes.first?.type.trimmed
    }

    public func inferredSuperclassType() -> TypeSyntax? {
        let inferrer = SuperclassTypeInferrer(for: self)
        return inferrer.infer()
    }
}

extension ClassDeclSyntax {

    private final class SuperclassTypeInferrer: SyntaxVisitor {

        private let classDecl: ClassDeclSyntax
        private var didFind = false

        init(for classDecl: ClassDeclSyntax) {
            self.classDecl = classDecl
            super.init(viewMode: .sourceAccurate)
        }

        func infer() -> TypeSyntax? {
            if let superclassType = classDecl.possibleSuperclassType {
                walk(classDecl)
                return didFind ? superclassType : nil
            } else {
                return nil
            }
        }

        override func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
            node == classDecl ? .visitChildren : .skipChildren
        }

        override func visit(_ node: DeclModifierSyntax) -> SyntaxVisitorContinueKind {
            didFind = didFind || node.overrideSpecifier != nil
            return .visitChildren
        }

        override func visit(_: SuperExprSyntax) -> SyntaxVisitorContinueKind {
            didFind = true
            return .visitChildren
        }
    }
}
