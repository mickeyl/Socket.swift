// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SocketSwift",
    products: [
        .library(
            name: "SocketSwift",
            targets: ["SocketSwift"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "SocketSwift",
            dependencies: [
            ],
            path: "Sources",
            exclude: ["Info.plist"]
        ),
        .testTarget(
            name: "SocketSwiftTests",
            dependencies: ["SocketSwift"]
        ),
    ]
)
