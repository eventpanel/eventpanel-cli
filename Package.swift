// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "eventpanel-cli",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(
            name: "eventpanel",
            targets: ["eventpanel"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.5.0"),
        .package(url: "https://github.com/kean/Get", from: "2.2.1"),
        .package(url: "https://github.com/jpsim/Yams", from: "6.0.0"),
        .package(url: "https://github.com/SwiftGen/StencilSwiftKit", from: "2.10.1"),
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.18.4")
    ],
    targets: [
        .executableTarget(
            name: "eventpanel",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Get", package: "Get"),
                .product(name: "Yams", package: "Yams"),
                .product(name: "StencilSwiftKit", package: "StencilSwiftKit")
            ],
            resources: [
                .process("Plugins/SwiftGen/swift5.stencil")
            ]
        ),
        .testTarget(
            name: "EventPanelCLITests",
            dependencies: [
                "eventpanel",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Get", package: "Get"),
                .product(name: "Yams", package: "Yams"),
                .product(name: "StencilSwiftKit", package: "StencilSwiftKit"),
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
            ]
        )
    ]
)
