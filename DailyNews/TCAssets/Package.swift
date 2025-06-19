// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TCAssets",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .watchOS(.v8),
        .tvOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "TCAssets",
            targets: ["TCAssets"]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // No external dependencies needed for basic asset management
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        .target(
            name: "TCAssets",
            dependencies: [],
            path: "Sources/TCAssets",
            resources: [
                // Process resources to make them available as Bundle.module
                .process("../../Resources/Assets.xcassets"),
                .process("../../Resources/Localizations"),
                .process("../../Resources/Fonts"),
                // Copy any other resources as-is
                .copy("../../Resources")
            ]
        ),
        .testTarget(
            name: "TCAssetsTests",
            dependencies: ["TCAssets"]
        ),
    ]
)
