// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppUIKit",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "AppUIKit",
            targets: ["AppUIKit"]
        ),
    ],
    dependencies: [
        .package(path: "../AppColors")
    ],
    targets: [
        .target(
            name: "AppUIKit",
            dependencies: [
                "AppColors"
            ]
        ),
        .testTarget(
            name: "AppUIKitTests",
            dependencies: ["AppUIKit"]
        ),
    ]
)
