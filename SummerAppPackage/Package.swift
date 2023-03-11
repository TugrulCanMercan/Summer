// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SummerAppPackage",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SummerAppPackage",
            targets: ["SummerAppPackage"]),
        .library(name: "TugrulCan",
                 targets: ["TugrulCan"]),
        .library(name: "LoginSignUpModule",
                 targets: ["LoginSignUpModule"]),
        .library(name: "SignUpModule", targets: ["SignUpModule"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(path: "../UIComponentsPackage"),
        .package(path: "../InfrastructurePackage"),
        .package(path: "../TTCafeCommon"),
        .package(url: "https://github.com/google/GoogleSignIn-iOS", from: "7.0.0"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "9.6.0"),
        
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SummerAppPackage",
            dependencies: ["LoginSignUpModule"]),
        .testTarget(
            name: "SummerAppPackageTests",
            dependencies: ["SummerAppPackage"]),
        .target(name: "TugrulCan"),
        .target(name: "LoginSignUpModule",
                dependencies: ["UIComponentsPackage",
                               "InfrastructurePackage",
                               .product(name: "GoogleSignIn", package: "GoogleSignIn-iOS"),
                               .product(name: "GoogleSignInSwift", package: "GoogleSignIn-iOS"),
                               .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                               "TTCafeCommon"
                              ]
               ),
        .target(name: "SignUpModule",dependencies: ["UIComponentsPackage"])
    ]
)
