//
//  ParserResult.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 03/02/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

@dynamicMemberLookup
public class ParserResult {

    private var customValues = ParserResultCustomValues()

    public subscript<Value>(dynamicMember keyPath: WritableKeyPath<ParserResultCustomValues, Value>) -> Value {
        get {
            customValues[keyPath: keyPath]
        }
        set {
            customValues[keyPath: keyPath] = newValue
        }
    }
}
