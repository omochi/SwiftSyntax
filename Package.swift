// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "SwiftSyntax",
    products: [
        .library(
            name: "SwiftSyntax",
            targets: ["SwiftSyntax"]),
        .executable(
            name: "format-example",
            targets: ["format-example"])
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "SwiftSyntax",
            dependencies: []),
        .target(
            name: "format-example",
            dependencies: ["SwiftSyntax"]),
    ]
)
