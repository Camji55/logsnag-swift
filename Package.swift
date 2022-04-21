// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "LogSnag",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "LogSnag",
            targets: ["LogSnag"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "LogSnag",
            dependencies: []),
        .testTarget(
            name: "LogSnagTests",
            dependencies: ["LogSnag"]),
    ]
)
