// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PrincipleMacros",
    platforms: [
        .macOS(.v14),
        .macCatalyst(.v17),
        .iOS(.v17),
        .tvOS(.v17),
        .watchOS(.v10),
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
            url: "https://github.com/swiftlang/swift-syntax",
            "600.0.0" ..< "604.0.0"
        )
    ],
    targets: [
        .target(
            name: "PrincipleMacros",
            dependencies: [
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
