//
//  ExprBuilder.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 07/02/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntax

public protocol ExprBuilder<Result> {

    associatedtype Result: SyntaxProtocol

    func build() throws -> Result
}
