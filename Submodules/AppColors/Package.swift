// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppColors",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "AppColors",
            targets: ["AppColors"]
        ),
    ],
    targets: [
        .target(
            name: "AppColors",
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "AppColorsTests",
            dependencies: ["AppColors"]
        ),
    ]
)
