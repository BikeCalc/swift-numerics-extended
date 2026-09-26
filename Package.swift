// swift-tools-version:6.3

import PackageDescription

let package = Package(
    name: "swift-numerics-extended",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "NumericsExtended",
            targets: [
                "NumericsExtended"
            ]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/swiftlang/swift-docc-plugin.git",
            from: "1.5.0"
        ),
        .package(
            url: "https://github.com/swiftlang/swift-format.git",
            from: "603.0.0"
        )
    ],
    targets: [
        .executableTarget(
            name: "NumericsExtendedBenchmarks",
            dependencies: [
                "NumericsExtended"
            ],
            path: "Tools/NumericsExtendedBenchmarks"
        ),
        .plugin(
            name: "NumericsExtendedBenchmarksPlugin",
            capability: .command(
                intent: .custom(
                    verb: "benchmark",
                    description: "Run and compare the benchmarks"
                ),
                permissions: [
                    .allowNetworkConnections(
                        scope: .all(),
                        reason: "Resolve dependencies while building benchmark revisions"
                    )
                ]
            )
        ),
        .plugin(
            name: "NumericsExtendedLinterPlugin",
            capability: .command(
                intent: .custom(
                    verb: "lint",
                    description: "Lint all Swift source files"
                )
            ),
            dependencies: [
                .product(
                    name: "swift-format",
                    package: "swift-format"
                )
            ]
        ),
        .target(
            name: "CoreNumericOperators"
        ),
        .target(
            name: "CoreNumericProtocols",
            dependencies: [
                "CoreNumericOperators"
            ]
        ),
        .target(
            name: "ExperimentalNumericConstants"
        ),
        .target(
            name: "ExperimentalNumericProtocols",
            dependencies: [
                "CoreNumericProtocols"
            ]
        ),
        .target(
            name: "ExperimentalNumericTypes",
            dependencies: [
                "CoreNumericOperators",
                "CoreNumericProtocols",
                "ExperimentalNumericProtocols",
                "StandardNumericProtocols",
                "StandardNumericTypes"
            ]
        ),
        .target(
            name: "NumericsExtended",
            dependencies: [
                "CoreNumericOperators",
                "CoreNumericProtocols",
                "ExperimentalNumericConstants",
                "ExperimentalNumericProtocols",
                "ExperimentalNumericTypes",
                "StandardNumericProtocols",
                "StandardNumericTypes"
            ]
        ),
        .target(
            name: "StandardNumericProtocols",
            dependencies: [
                "CoreNumericOperators",
                "CoreNumericProtocols"
            ]
        ),
        .target(
            name: "StandardNumericTypes",
            dependencies: [
                "CoreNumericProtocols",
                "StandardNumericProtocols"
            ]
        ),
        .testTarget(
            name: "NumericsExtendedUnitTests",
            dependencies: [
                "NumericsExtended"
            ]
        )
    ],
    swiftLanguageModes: [.v6]
)
