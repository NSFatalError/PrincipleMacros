//
//  AccessControlLevel.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 13/11/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

public enum AccessControlLevel: Int, Hashable, CaseIterable {

    case `private`
    case `fileprivate`
    case `internal`
    case package
    case `public`
    case open

    public var keyword: Keyword {
        switch self {
        case .private:
            .private
        case .fileprivate:
            .fileprivate
        case .internal:
            .internal
        case .package:
            .package
        case .public:
            .public
        case .open:
            .open
        }
    }

    public var tokenSyntax: TokenSyntax {
        TokenSyntax(
            .keyword(keyword),
            presence: .present
        )
    }

    public init?(keyword: Keyword) {
        switch keyword {
        case .private:
            self = .private
        case .fileprivate:
            self = .fileprivate
        case .internal:
            self = .internal
        case .package:
            self = .package
        case .public:
            self = .public
        case .open:
            self = .open
        default:
            return nil
        }
    }

    public init?(tokenSyntax: TokenSyntax) {
        switch tokenSyntax.tokenKind {
        case let .keyword(keyword):
            self.init(keyword: keyword)
        default:
            return nil
        }
    }
}

extension AccessControlLevel: Comparable {

    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

extension AccessControlLevel {

    public static func forMember(
        of declaration: some TypeDeclSyntax,
        preferred: Self?,
        maxAllowed: Self
    ) -> Self? {
        _resolved(
            from: declaration.accessControlLevel,
            preferred: preferred,
            maxAllowed: maxAllowed,
            transform: { $0 == .private ? nil : $0 }
        )
    }

    public static func forSibling(
        of syntax: some WithModifiersSyntax,
        preferred: Self?,
        maxAllowed: Self
    ) -> Self? {
        _resolved(
            from: syntax.accessControlLevel,
            preferred: preferred,
            maxAllowed: maxAllowed,
            transform: { $0 == .private ? .fileprivate : $0 }
        )
    }

    public static func forPeer(
        of syntax: some WithModifiersSyntax,
        preferred: Self?,
        maxAllowed: Self
    ) -> Self? {
        _resolved(
            from: syntax.accessControlLevel,
            preferred: preferred,
            maxAllowed: maxAllowed
        )
    }

    private static func _resolved(
        from attached: Self?,
        preferred: Self?,
        maxAllowed: Self,
        transform: (Self) -> Self? = \.self
    ) -> Self? {
        if let preferred {
            return min(preferred, maxAllowed)
        }
        if var attached {
            attached = min(attached, maxAllowed)
            return transform(attached)
        }
        return nil
    }
}

extension SyntaxStringInterpolation {

    public mutating func appendInterpolation(_ accessControlLevel: AccessControlLevel?) {
        let node = accessControlLevel?.tokenSyntax.withTrailingSpace
        appendInterpolation(node)
    }
}
