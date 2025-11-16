//
//  AccessorDeclListSyntax.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 12/01/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import SwiftSyntaxMacros

extension AccessorDeclListSyntax {

    public func withKeyword(_ keyword: Keyword) -> AccessorDeclSyntax? {
        first { accessor in
            accessor.accessorSpecifier.tokenKind == .keyword(keyword)
        }
    }
}
