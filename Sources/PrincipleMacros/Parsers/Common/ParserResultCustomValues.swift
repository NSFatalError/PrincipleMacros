//
//  ParserResultCustomValues.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 03/02/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

public struct ParserResultCustomValues {

    private var storage = [ObjectIdentifier: Any]()

    private func identifier(for customKey: (some ParserResultCustomKey).Type) -> ObjectIdentifier {
        ObjectIdentifier(customKey)
    }

    public subscript<Key: ParserResultCustomKey>(_ customKey: Key.Type) -> Key.Value {
        get {
            storage[identifier(for: customKey)] as? Key.Value ?? Key.defaultValue
        }
        set {
            storage[identifier(for: customKey)] = newValue
        }
    }
}
