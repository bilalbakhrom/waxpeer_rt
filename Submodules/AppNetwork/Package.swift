// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppNetwork",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "AppNetwork",
            targets: ["AppNetwork"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/socketio/socket.io-client-swift", .upToNextMinor(from: "16.1.0"))
    ],
    targets: [
        .target(
            name: "AppNetwork",
            dependencies: [
                .product(name: "SocketIO", package: "socket.io-client-swift")
            ]
        ),
        .testTarget(
            name: "AppNetworkTests",
            dependencies: ["AppNetwork"]
        ),
    ]
)
