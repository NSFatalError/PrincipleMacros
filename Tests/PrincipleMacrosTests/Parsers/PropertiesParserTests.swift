//
//  PropertiesParserTests.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 17/01/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

@testable import PrincipleMacros
import SwiftSyntaxMacroExpansion
import Testing

internal struct PropertiesParserTests {

    private let context = BasicMacroExpansionContext()

    @Test
    func testStoredLet() throws {
        let decl: DeclSyntax = """
        public static let myLet: Int?
        """
        let property = try #require(PropertiesParser.parse(declaration: decl, in: context).first)
        #expect(property.kind == .stored)
        #expect(property.mutability == .immutable)
        #expect(property.accessControlLevel?.trimmedDescription == "public")
        #expect(property.typeScopeSpecifier?.trimmedDescription == "static")
        #expect(property.trimmedName.description == "myLet")
        #expect(property.inferredType.description == "Optional<Int>")
        #expect(property.accessors == nil)
        #expect(property.observers == nil)
    }

    @Test
    func testStoredVar() throws {
        let decl: DeclSyntax = """
        private var myVar = "Hello, world!"
        """
        let property = try #require(PropertiesParser.parse(declaration: decl, in: context).first)
        #expect(property.kind == .stored)
        #expect(property.mutability == .mutable)
        #expect(property.accessControlLevel?.trimmedDescription == "private")
        #expect(property.typeScopeSpecifier == nil)
        #expect(property.trimmedName.description == "myVar")
        #expect(property.inferredType.description == "String")
        #expect(property.accessors == nil)
        #expect(property.observers == nil)
    }

    @Test
    func testStoredVarWithObservers() throws {
        let decl: DeclSyntax = """
        class var myObservedVar = UIView.Constraint.make() {
            willSet { print("willSet", newValue) }
            didSet { print("didSet", oldValue) }
        }
        """
        let property = try #require(PropertiesParser.parse(declaration: decl, in: context).first)
        #expect(property.kind == .stored)
        #expect(property.mutability == .mutable)
        #expect(property.accessControlLevel == nil)
        #expect(property.typeScopeSpecifier?.trimmedDescription == "class")
        #expect(property.trimmedName.description == "myObservedVar")
        #expect(property.inferredType.description == "UIView.Constraint")
        #expect(property.accessors == nil)
        #expect(property.observers?.willSet?.trimmedDescription == #"willSet { print("willSet", newValue) }"#)
        #expect(property.observers?.didSet?.trimmedDescription == #"didSet { print("didSet", oldValue) }"#)
    }

    @Test
    func testComputedVar() throws {
        let decl: DeclSyntax = """
        fileprivate var myComputedVar: [Model] { 
            [1, 2, 3] 
        }
        """
        let property = try #require(PropertiesParser.parse(declaration: decl, in: context).first)
        #expect(property.kind == .computed)
        #expect(property.mutability == .immutable)
        #expect(property.accessControlLevel?.trimmedDescription == "fileprivate")
        #expect(property.typeScopeSpecifier == nil)
        #expect(property.trimmedName.description == "myComputedVar")
        #expect(property.inferredType.description == "Array<Model>")
        #expect(property.accessors?.implicitGetter?.trimmedDescription == "[1, 2, 3]")
        #expect(property.observers == nil)
    }

    @Test
    func testComputedVarWithSetter() throws {
        let decl: DeclSyntax = """
        static var mySettableVar: [Model]! { 
            get { _storage } 
            set { _storage = newValue }
        }
        """
        let property = try #require(PropertiesParser.parse(declaration: decl, in: context).first)
        #expect(property.kind == .computed)
        #expect(property.mutability == .mutable)
        #expect(property.accessControlLevel == nil)
        #expect(property.typeScopeSpecifier?.trimmedDescription == "static")
        #expect(property.trimmedName.description == "mySettableVar")
        #expect(property.inferredType.description == "Optional<Array<Model>>")
        #expect(property.accessors?.getter?.trimmedDescription == "get { _storage }")
        #expect(property.accessors?.setter?.trimmedDescription == "set { _storage = newValue }")
        #expect(property.observers == nil)
    }
}
