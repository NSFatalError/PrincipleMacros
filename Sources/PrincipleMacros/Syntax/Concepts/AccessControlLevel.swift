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

    public func inheritedByMember(
        maxAllowed: Self = .public
    ) -> Self? {
        switch self {
        case .private:
            nil
        default:
            min(self, maxAllowed)
        }
    }

    public func inheritedBySibling(
        maxAllowed: Self = .public
    ) -> Self {
        switch self {
        case .private:
            min(.fileprivate, maxAllowed)
        default:
            min(self, maxAllowed)
        }
    }

    public func inheritedByPeer(
        maxAllowed: Self = .public
    ) -> Self {
        min(self, maxAllowed)
    }

    public static func forMember(
        of declaration: some TypeDeclSyntax,
        preferred: Self? = nil,
        maxAllowed: Self = .public
    ) -> Self? {
        _resolved(
            from: declaration.accessControlLevel,
            preferred: preferred,
            maxAllowed: maxAllowed,
            transform: { $0.inheritedByMember(maxAllowed: maxAllowed) }
        )
    }

    public static func forSibling(
        of syntax: some WithModifiersSyntax,
        preferred: Self? = nil,
        maxAllowed: Self = .public
    ) -> Self? {
        _resolved(
            from: syntax.accessControlLevel,
            preferred: preferred,
            maxAllowed: maxAllowed,
            transform: { $0.inheritedBySibling(maxAllowed: maxAllowed) }
        )
    }

    public static func forPeer(
        of syntax: some WithModifiersSyntax,
        preferred: Self? = nil,
        maxAllowed: Self = .public
    ) -> Self? {
        _resolved(
            from: syntax.accessControlLevel,
            preferred: preferred,
            maxAllowed: maxAllowed,
            transform: { $0.inheritedByPeer(maxAllowed: maxAllowed) }
        )
    }

    private static func _resolved(
        from attached: Self?,
        preferred: Self?,
        maxAllowed: Self,
        transform: (Self) -> Self?
    ) -> Self? {
        if let preferred {
            return min(preferred, maxAllowed)
        }
        if let attached {
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
