// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NetworkManager",
    products: [
        .library(
            name: "NetworkManager",
            targets: ["NetworkManager"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "NetworkManager",
            dependencies: []),
        .testTarget(
            name: "NetworkManagerTests",
            dependencies: ["NetworkManager"]),
    ]
)
