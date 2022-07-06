// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "HTTP Client",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "HTTP",
            targets: ["HTTP"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "HTTP",
            dependencies: []
        ),
        .testTarget(
            name: "HTTPTests",
            dependencies: ["HTTP"]
        ),
    ]
)
