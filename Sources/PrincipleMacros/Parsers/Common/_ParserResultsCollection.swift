//
//  _ParserResultsCollection.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 22/01/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

internal protocol _ParserResultsCollection: ParserResultsCollection {

    init(_ all: [Element])
}

extension _ParserResultsCollection {

    init() {
        self.init([])
    }
}
