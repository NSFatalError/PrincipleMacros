//
//  Property.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 12/01/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntax

@dynamicMemberLookup
public final class Property: ParserResult {

    public let declaration: VariableDeclSyntax
    public let binding: PatternBindingSyntax
    public let trimmedName: TokenSyntax
    public let inferredType: TypeSyntax

    public let kind: Kind
    public let mutability: Mutability
    public let observers: StoredObservers?
    public let accessors: ComputedAccessors?

    init(
        declaration: VariableDeclSyntax,
        binding: PatternBindingSyntax,
        name: TokenSyntax,
        inferredType: TypeSyntax
    ) {
        self.declaration = declaration
        self.binding = binding
        self.trimmedName = name.trimmed
        self.inferredType = inferredType

        if declaration.bindingSpecifier.tokenKind == .keyword(.let) {
            self.kind = .stored
            self.mutability = .immutable
            self.observers = nil
            self.accessors = nil

        } else if let accessorBlock = binding.accessorBlock {
            switch accessorBlock.accessors {
            case let .accessors(accessors):
                let willSet = accessors.withKeyword(.willSet)
                let didSet = accessors.withKeyword(.didSet)
                let getter = accessors.withKeyword(.get)
                let setter = accessors.withKeyword(.set)

                if let getter {
                    self.kind = .computed
                    self.mutability = setter == nil ? .immutable : .mutable
                    self.observers = nil
                    self.accessors = .init(block: accessorBlock, getter: getter, setter: setter)
                } else {
                    self.kind = .stored
                    self.mutability = .mutable
                    self.observers = .init(block: accessorBlock, willSet: willSet, didSet: didSet)
                    self.accessors = nil
                }

            case let .getter(getter):
                self.kind = .computed
                self.mutability = .immutable
                self.observers = nil
                self.accessors = .init(block: accessorBlock, implicitGetter: getter)
            }

        } else {
            self.kind = .stored
            self.mutability = .mutable
            self.observers = nil
            self.accessors = nil
        }
    }

    public subscript<T>(dynamicMember keyPath: KeyPath<VariableDeclSyntax, T>) -> T {
        declaration[keyPath: keyPath]
    }
}

extension Property {

    public enum Kind {

        case computed
        case stored
    }

    public enum Mutability {

        case immutable
        case mutable
    }

    public struct ComputedAccessors {

        public let block: AccessorBlockSyntax
        public let implicitGetter: CodeBlockItemListSyntax?
        public let getter: AccessorDeclSyntax?
        public let setter: AccessorDeclSyntax?

        fileprivate init(
            block: AccessorBlockSyntax,
            implicitGetter: CodeBlockItemListSyntax
        ) {
            self.block = block
            self.implicitGetter = implicitGetter
            self.getter = nil
            self.setter = nil
        }

        fileprivate init(
            block: AccessorBlockSyntax,
            getter: AccessorDeclSyntax,
            setter: AccessorDeclSyntax?
        ) {
            self.block = block
            self.implicitGetter = nil
            self.getter = getter
            self.setter = setter
        }
    }

    public struct StoredObservers {

        public let block: AccessorBlockSyntax
        public let willSet: AccessorDeclSyntax?
        public let didSet: AccessorDeclSyntax?
    }
}
