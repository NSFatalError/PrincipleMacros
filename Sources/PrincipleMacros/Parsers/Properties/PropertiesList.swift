//
//  PropertiesList.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 14/01/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntax

public struct PropertiesList: _ParserResultsCollection {

    public let all: [Property]

    init(_ all: [Property]) {
        self.all = all
    }
}

extension PropertiesList {

    public var immutable: Self {
        .init(filter { $0.mutability == .immutable })
    }

    public var mutable: Self {
        .init(filter { $0.mutability == .mutable })
    }

    public var instance: Self {
        .init(filter { $0.typeScopeSpecifier == nil })
    }

    public var type: Self {
        .init(filter { $0.typeScopeSpecifier != nil })
    }

    public var stored: Self {
        .init(filter { $0.kind == .stored })
    }

    public var computed: Self {
        .init(filter { $0.kind == .computed })
    }
}

extension PropertiesList {

    public func withInferredType(like someType: TypeSyntax) -> Self {
        .init(filter { $0.inferredType.isLike(someType) })
    }
}
