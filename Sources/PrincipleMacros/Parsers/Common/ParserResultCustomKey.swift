//
//  ParserResultCustomKey.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 03/02/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

public protocol ParserResultCustomKey<Value> {

    associatedtype Value

    static var defaultValue: Value { get }
}
