// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "HTTP Client",
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
