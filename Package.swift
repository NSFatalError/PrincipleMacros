// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PrincipleMacros",
    platforms: [
        .macOS(.v13),
        .macCatalyst(.v16),
        .iOS(.v16),
        .tvOS(.v16),
        .watchOS(.v9),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "PrincipleMacros",
            targets: ["PrincipleMacros"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/NSFatalError/Principle",
            from: "0.0.1"
        ),
        .package(
            url: "https://github.com/swiftlang/swift-syntax",
            from: "600.0.0-latest"
        ),
        .package(
            url: "https://github.com/apple/swift-algorithms",
            from: "1.2.0"
        )
    ],
    targets: [
        .target(
            name: "PrincipleMacros",
            dependencies: [
                .product(
                    name: "Principle",
                    package: "Principle"
                ),
                .product(
                    name: "Algorithms",
                    package: "swift-algorithms"
                ),
                .product(
                    name: "SwiftSyntaxMacros",
                    package: "swift-syntax"
                )
            ]
        ),
        .testTarget(
            name: "PrincipleMacrosTests",
            dependencies: [
                "PrincipleMacros",
                .product(
                    name: "SwiftSyntaxMacroExpansion",
                    package: "swift-syntax"
                )
            ]
        )
    ]
)
