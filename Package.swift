// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppCoordinator",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(name: "AppCoordinator", targets: ["AppCoordinator"]),
    ],
    targets: [
        .target(name: "AppCoordinator", path: "Sources/AppCoordinator"),
    ]
)
