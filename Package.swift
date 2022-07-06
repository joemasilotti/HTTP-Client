// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "HTTP Client",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
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
