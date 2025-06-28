// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
let package = Package(
    name: "azookeyKanaKanji",
    dependencies: [
        .package(url: "https://github.com/azooKey/AzooKeyKanaKanjiConverter", branch: "7d5dd99")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "azookeyKanaKanji",
             dependencies: [
                .product(name: "KanaKanjiConverterModuleWithDefaultDictionary", package: "AzooKeyKanaKanjiConverter")
             ]
        )
    ]
)
