// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "InfrastructurePackage",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "InfrastructurePackage",
            targets: ["InfrastructurePackage"]),
        .library(
            name: "FirebaseManager",
            targets: ["FirebaseManager"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "9.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "InfrastructurePackage",
            dependencies: []),
        .testTarget(
            name: "InfrastructurePackageTests",
            dependencies: ["InfrastructurePackage"]),
        .target(
            name: "FirebaseManager",
            dependencies: [
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk")
            ]),
    ]
)
