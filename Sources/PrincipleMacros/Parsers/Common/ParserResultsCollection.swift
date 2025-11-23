//
//  ParserResultsCollection.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 14/01/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

public protocol ParserResultsCollection<Element>: RandomAccessCollection
where Element: ParserResult {

    associatedtype Element

    var all: [Element] { get }

    init(_ all: [Element])
}

extension ParserResultsCollection {

    public var startIndex: Int {
        all.startIndex
    }

    public var endIndex: Int {
        all.endIndex
    }

    public subscript(position: Int) -> Element {
        all[position]
    }
}

extension ParserResultsCollection {

    public init() {
        self.init([])
    }

    public func filter(
        _ isIncluded: (Element) throws -> Bool
    ) rethrows -> Self {
        try Self(filter(isIncluded))
    }
}
