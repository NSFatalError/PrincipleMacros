//
//  ClassDeclSyntax.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 21/11/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntaxMacros

extension ClassDeclSyntax {

    public func inferredSuperclassType(
        isKnownToBeSubclass: Bool = false
    ) -> TypeSyntax? {
        let finder = SuperclassFinder(for: self)
        let needsCheck = !isKnownToBeSubclass
        return finder.find(checkAgainstSubclassSpecificKeywords: needsCheck)
    }
}

extension ClassDeclSyntax {

    private final class SuperclassFinder: SyntaxVisitor {

        private let classDecl: ClassDeclSyntax
        private var didFind = false

        init(for classDecl: ClassDeclSyntax) {
            self.classDecl = classDecl
            super.init(viewMode: .sourceAccurate)
        }

        func find(checkAgainstSubclassSpecificKeywords: Bool) -> TypeSyntax? {
            guard let inheritedTypes = classDecl.inheritanceClause?.inheritedTypes,
                  let superclassType = inheritedTypes.first?.type.trimmed
            else {
                return nil
            }

            if checkAgainstSubclassSpecificKeywords {
                walk(classDecl)
                return didFind ? superclassType : nil
            } else {
                return superclassType
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
