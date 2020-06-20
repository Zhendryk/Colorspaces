// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Colorspaces",
    platforms: [
      .iOS(.v12)
    ],
    products: [
        .library(
            name: "Colorspaces",
            targets: ["Colorspaces"]),
    ],
    targets: [
        .target(
            name: "Colorspaces",
            path: "Source"),
        .testTarget(
            name: "ColorspacesTests",
            dependencies: ["Colorspaces"],
            path: "Tests"),
    ],
    swiftLanguageVersions: [.v5]
)
