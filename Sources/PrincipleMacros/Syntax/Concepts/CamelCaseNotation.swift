//
//  CamelCaseNotation.swift
//  PrincipleMacros
//
//  Created by Kamil Strzelecki on 14/11/2025.
//  Copyright © 2025 Kamil Strzelecki. All rights reserved.
//

import Foundation
import SwiftSyntaxMacros

public struct CamelCaseNotation {

    public var segments: [Segment]

    public init(segments: some Sequence<Segment>) {
        self.segments = Array(segments)
    }

    public init(string: String) {
        var segments = [Segment]()
        var segment: MutableSegment?

        func appendSegment(_ segment: MutableSegment) {
            segments.append(Segment(from: segment, in: string))
        }

        for (index, character) in zip(string.indices.reversed(), string.reversed()) {
            let characterSpelling = Segment.Spelling(character)

            guard var oldSegment = segment else {
                segment = MutableSegment(index: index, spelling: characterSpelling)
                continue
            }

            switch (characterSpelling, oldSegment.spelling) {
            case (.lowercase, .uppercase): // a|B
                appendSegment(oldSegment)
                segment = MutableSegment(index: index, spelling: .lowercase)

            case (.uppercase, .lowercase): // |Ab
                oldSegment.expand(to: index)
                oldSegment.spelling = .capitalized
                appendSegment(oldSegment)
                segment = nil

            default:
                segment?.expand(to: index)
            }
        }

        if let segment {
            appendSegment(segment)
        }

        self.segments = segments.reversed()
    }

    public func joined(as spelling: Spelling) -> String {
        var joined = segments.first?
            .string(as: spelling)
            ?? ""
        joined += segments.dropFirst()
            .map { $0.string(as: .upperCamelCase) }
            .joined()
        return joined
    }
}

extension CamelCaseNotation {

    public enum Spelling: Hashable {

        case lowerCamelCase
        case upperCamelCase
    }
}

extension CamelCaseNotation {

    fileprivate struct MutableSegment: Hashable {

        var range: ClosedRange<String.Index>
        var spelling: Segment.Spelling

        init(index: String.Index, spelling: Segment.Spelling) {
            self.range = index ... index
            self.spelling = spelling
        }

        mutating func expand(to index: String.Index) {
            range = index ... range.upperBound
        }
    }

    public struct Segment: Hashable {

        public let string: String
        public let spelling: Spelling

        public init(string: String, spelling: Spelling) {
            self.string = string
            self.spelling = spelling
        }

        fileprivate init(from segment: MutableSegment, in string: String) {
            self.string = String(string[segment.range])
            self.spelling = segment.spelling
        }

        public func string(as transform: CamelCaseNotation.Spelling) -> String {
            switch transform {
            case .lowerCamelCase:
                string.lowercased()
            case .upperCamelCase:
                spelling == .uppercase
                    ? string.uppercased()
                    : string.capitalized
            }
        }
    }
}

extension CamelCaseNotation.Segment {

    public enum Spelling: Hashable {

        case lowercase
        case capitalized
        case uppercase

        fileprivate init(_ character: Character) {
            self = character.isUppercase ? .uppercase : .lowercase
        }
    }
}
