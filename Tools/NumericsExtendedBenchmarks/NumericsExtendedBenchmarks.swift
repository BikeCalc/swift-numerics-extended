// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Foundation

/// The command-line entry point for running the Numerics Extended benchmarks.
@main
internal enum NumericsExtendedBenchmarks {
    internal static func main() {
        do {
            let arguments: BenchmarkArguments = try .init(Array(CommandLine.arguments.dropFirst()))

            if #available(iOS 16.0, macCatalyst 16.0, macOS 13.0, tvOS 16.0, visionOS 1.0, watchOS 9.0, *) {
                try self.runBenchmarks(arguments: arguments)
            } else {
                throw BenchmarkCommandError.unsupportedPlatform
            }
        } catch {
            FileHandle.standardError.write(Data("\(error)\n".utf8))
            exit(EXIT_FAILURE)
        }
    }

    @available(iOS 16.0, macCatalyst 16.0, macOS 13.0, tvOS 16.0, visionOS 1.0, watchOS 9.0, *)
    private static func runBenchmarks(arguments: BenchmarkArguments) throws {
        let benchmarks: Array<Benchmark> = fractionBenchmarks + canonicalizedFractionBenchmarks
        let report: BenchmarkReport = BenchmarkRunner().run(benchmarks)
        let encoder: JSONEncoder = .init()
        encoder.outputFormatting = [
            .prettyPrinted,
            .sortedKeys
        ]
        let data: Data = try encoder.encode(report)

        if let outputURL = arguments.outputURL {
            try data.write(to: outputURL)

            for result in report.results {
                print("\(result.name): \(String(format: "%.2f ns", result.medianNanosecondsPerOperation))")
            }

            print("\nWrote benchmark report to \(outputURL.path)")
        } else {
            FileHandle.standardOutput.write(data)
            FileHandle.standardOutput.write(Data("\n".utf8))
        }
    }
}
