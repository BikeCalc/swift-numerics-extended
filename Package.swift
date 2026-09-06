// swift-tools-version:6.3

import PackageDescription

let package = Package(
    name: "swift-numerics-extended",
    defaultLocalization: "en",
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
        ),
    ],
    targets: [
        .executableTarget(
            name: "NumericsExtendedBenchmarks",
            dependencies: [
                "NumericsExtended"
            ],
            path: "Benchmarks/NumericsExtendedBenchmarks"
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
            name: "NumericsExtendedTests",
            dependencies: [
                "NumericsExtended"
            ]
        )
    ],
    swiftLanguageModes: [.v6]
)
