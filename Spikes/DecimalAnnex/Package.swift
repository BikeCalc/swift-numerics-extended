// swift-tools-version: 6.4

import PackageDescription

let package: Package = .init(
    name: "DecimalAnnexEvaluation",
    platforms: [.macOS(.v13)],
    products: [
        .library(name: "DecimalAnnexIntegration", targets: ["DecimalAnnexIntegration"]),
        .executable(name: "DecimalAnnexCompatibilityProbe", targets: ["DecimalAnnexCompatibilityProbe"])
    ],
    dependencies: [
        .package(name: "swift-numerics-extended", path: "../.."),
        .package(
            url: "https://github.com/xwu/DecimalAnnex.git",
            revision: "baef9ff4ad67f87082fa6aa8c5a1e154d1a284ac",
            traits: []
        )
    ],
    targets: [
        .target(
            name: "DecimalAnnexIntegration",
            dependencies: [
                .product(name: "NumericsExtended", package: "swift-numerics-extended"),
                .product(name: "DecimalCore", package: "DecimalAnnex")
            ]
        ),
        .testTarget(
            name: "DecimalAnnexIntegrationTests",
            dependencies: ["DecimalAnnexIntegration"]
        ),
        .executableTarget(
            name: "DecimalAnnexCompatibilityProbe",
            dependencies: ["DecimalAnnexIntegration"]
        )
    ],
    swiftLanguageModes: [.v6]
)
