// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PrincipleMacros",
    platforms: [
        .macOS(.v15),
        .macCatalyst(.v18),
        .iOS(.v18),
        .tvOS(.v18),
        .watchOS(.v11),
        .visionOS(.v2)
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
            from: "1.0.0"
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
                    name: "PrincipleCollections",
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

for target in package.targets {
    target.swiftSettings = (target.swiftSettings ?? []) + [
        .swiftLanguageMode(.v6),
        .enableUpcomingFeature("ExistentialAny")
    ]
}
