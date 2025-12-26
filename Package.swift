// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Gedcom",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Gedcom",
            targets: ["Gedcom"]),
    ],
    dependencies: [
        // ZIPFoundation добавляем ТОЛЬКО как зависимость
        .package(url: "https://github.com/weichsel/ZIPFoundation", from: "0.9.20")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Gedcom"
        ),
        .testTarget(
            name: "GedcomTests",
            dependencies: [
                "Gedcom",
                .product(name: "ZIPFoundation", package: "ZIPFoundation"),
            ],
            resources: [.copy("Gedcom7")]
        ),
    ]
)
