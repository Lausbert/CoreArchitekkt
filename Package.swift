// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "CoreArchitekkt",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "CoreArchitekkt",
            targets: ["CoreArchitekkt"]),
    ],
    targets: [
        .target(
            name: "CoreArchitekkt",
            dependencies: []),
        .testTarget(
            name: "CoreArchitekktTests",
            dependencies: ["CoreArchitekkt"]),
    ]
)
