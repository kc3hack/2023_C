// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "calculator_for_iPad_core",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "calculator_for_iPad_core",
            targets: ["calculator_for_iPad_core"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "calculator_for_iPad_core",
            dependencies: []),
        .testTarget(
            name: "calculator_for_iPad_core.Tests",
            dependencies: ["calculator_for_iPad_core"]),
    ]
)
