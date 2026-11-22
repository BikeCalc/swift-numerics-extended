// swift-tools-version: 6.4

import PackageDescription

let package: Package = .init(
    name: "DecimalAnnexMacroProbe",
    platforms: [.macOS(.v26)],
    dependencies: [
        .package(
            url: "https://github.com/xwu/DecimalAnnex.git",
            revision: "baef9ff4ad67f87082fa6aa8c5a1e154d1a284ac"
        )
    ],
    targets: [
        .testTarget(
            name: "DecimalAnnexMacroTests",
            dependencies: [.product(name: "DecimalAnnex", package: "DecimalAnnex")]
        )
    ],
    swiftLanguageModes: [.v6]
)
