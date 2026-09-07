// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Foundation
import PackagePlugin

/// Runs and compares Numerics Extended benchmarks through Swift Package Manager.
@main
internal struct NumericsExtendedBenchmarksPlugin {
    /// Extracts, prepares, and measures an optional baseline revision.
    ///
    /// The current benchmark definitions replace those in the baseline so both revisions measure the same operations.
    ///
    /// - Parameters:
    ///   - revision: The Git revision to measure.
    ///   - packageURL: The root directory of the current package.
    ///   - baselinePackageURL: The directory into which the baseline package should be extracted.
    ///   - baselineBuildURL: The isolated SwiftPM build directory for the baseline.
    ///   - baselineReportURL: The destination for the encoded baseline report.
    ///   - swiftPMArguments: Shared SwiftPM storage arguments used by both benchmark builds.
    /// - Returns: `true` when a comparable baseline was measured; otherwise, `false`.
    /// - Throws: An error when the revision cannot be prepared or its benchmarks cannot be run.
    private func prepareBaseline(
        revision: String,
        packageURL: URL,
        baselinePackageURL: URL,
        baselineBuildURL: URL,
        baselineReportURL: URL,
        swiftPMArguments: Array<String>
    ) throws -> Bool {
        let fileManager: FileManager = .default
        let archiveURL: URL = baselinePackageURL.deletingLastPathComponent().appendingPathComponent("baseline.tar")

        for url in [baselinePackageURL, archiveURL] where fileManager.fileExists(atPath: url.path) {
            try fileManager.removeItem(at: url)
        }

        try fileManager.createDirectory(
            at: baselinePackageURL,
            withIntermediateDirectories: true
        )

        Diagnostics.remark("Preparing baseline revision \(revision)")
        try ProcessRunner.run(
            command: "git",
            arguments: [
                "archive",
                "--format=tar",
                "--output",
                archiveURL.path,
                "--",
                revision
            ],
            workingDirectoryURL: packageURL
        )
        try ProcessRunner.run(
            command: "tar",
            arguments: [
                "--extract",
                "--file",
                archiveURL.path,
                "--directory",
                baselinePackageURL.path
            ],
            workingDirectoryURL: packageURL
        )
        try fileManager.removeItem(at: archiveURL)

        let manifestURL: URL = baselinePackageURL.appendingPathComponent("Package.swift")
        let manifest: String = try .init(contentsOf: manifestURL, encoding: .utf8)
        let baselineBenchmarksPath: String

        if manifest.contains("path: \"Tools/NumericsExtendedBenchmarks\"") {
            baselineBenchmarksPath = "Tools/NumericsExtendedBenchmarks"
        } else if manifest.contains("path: \"Benchmarks/NumericsExtendedBenchmarks\"") {
            baselineBenchmarksPath = "Benchmarks/NumericsExtendedBenchmarks"
        } else {
            Diagnostics.remark("The baseline predates the benchmark target; reporting the current revision only")
            return false
        }

        let currentBenchmarksURL: URL = packageURL.appendingPathComponent("Tools/NumericsExtendedBenchmarks")
        let baselineBenchmarksURL: URL = baselinePackageURL.appendingPathComponent(
            baselineBenchmarksPath
        )

        if fileManager.fileExists(atPath: baselineBenchmarksURL.path) {
            try fileManager.removeItem(at: baselineBenchmarksURL)
        }

        try fileManager.createDirectory(
            at: baselineBenchmarksURL.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )
        try fileManager.copyItem(
            at: currentBenchmarksURL,
            to: baselineBenchmarksURL
        )

        Diagnostics.remark("Running baseline benchmarks")
        try ProcessRunner.run(
            command: "swift",
            arguments: ["run"] + swiftPMArguments + [
                "--disable-sandbox",
                "--disable-experimental-prebuilts",
                "--package-path",
                baselinePackageURL.path,
                "--scratch-path",
                baselineBuildURL.path,
                "--configuration",
                "release",
                "NumericsExtendedBenchmarks",
                "--output",
                baselineReportURL.path
            ],
            workingDirectoryURL: baselinePackageURL
        )

        return true
    }
}

// MARK: - CommandPlugin

extension NumericsExtendedBenchmarksPlugin: CommandPlugin {
    /// Runs the current benchmarks and optionally compares them with a Git revision.
    ///
    /// - Parameters:
    ///   - context: The package and plugin work directories provided by SwiftPM.
    ///   - arguments: The command-line arguments passed after the plugin verb.
    /// - Throws: An error when argument parsing, benchmark execution, or report comparison fails.
    internal func performCommand(
        context: PluginContext,
        arguments: Array<String>
    ) async throws {
        var argumentExtractor: ArgumentExtractor = .init(arguments)
        _ = argumentExtractor.extractOption(named: "target")
        let arguments: NumericsExtendedBenchmarksPluginArguments = try .init(argumentExtractor.remainingArguments)

        if arguments.showsHelp {
            print(NumericsExtendedBenchmarksPluginError.usage)
            return
        }

        let packageURL: URL = context.package.directoryURL
        let workURL: URL = context.pluginWorkDirectoryURL
        let currentReportURL: URL = workURL.appendingPathComponent("benchmark-current.json")
        let baselineReportURL: URL = workURL.appendingPathComponent("benchmark-baseline.json")
        let baselinePackageURL: URL = workURL.appendingPathComponent("baseline")
        let currentBuildURL: URL = workURL.appendingPathComponent("current-build")
        let baselineBuildURL: URL = workURL.appendingPathComponent("baseline-build")
        let swiftPMStorageURL: URL = workURL.appendingPathComponent("swiftpm")
        let swiftPMArguments: Array<String> = [
            "--cache-path",
            swiftPMStorageURL.appendingPathComponent("cache").path,
            "--config-path",
            swiftPMStorageURL.appendingPathComponent("configuration").path,
            "--security-path",
            swiftPMStorageURL.appendingPathComponent("security").path
        ]

        try FileManager.default.createDirectory(
            at: workURL,
            withIntermediateDirectories: true
        )

        let baselineIsAvailable: Bool = try self.prepareBaseline(
            revision: arguments.baselineRevision,
            packageURL: packageURL,
            baselinePackageURL: baselinePackageURL,
            baselineBuildURL: baselineBuildURL,
            baselineReportURL: baselineReportURL,
            swiftPMArguments: swiftPMArguments
        )

        Diagnostics.remark("Running current benchmarks")
        try ProcessRunner.run(
            command: "swift",
            arguments: ["run"] + swiftPMArguments + [
                "--disable-sandbox",
                "--disable-experimental-prebuilts",
                "--package-path",
                packageURL.path,
                "--scratch-path",
                currentBuildURL.path,
                "--configuration",
                "release",
                "NumericsExtendedBenchmarks",
                "--output",
                currentReportURL.path
            ],
            workingDirectoryURL: packageURL
        )

        var comparisonArguments: Array<String> = [
            packageURL.appendingPathComponent("Scripts/CompareBenchmarkResults.swift").path,
            "--current",
            currentReportURL.path
        ]

        if baselineIsAvailable {
            comparisonArguments.append(contentsOf: [
                "--baseline",
                baselineReportURL.path
            ])
        }

        let summary: Data = try ProcessRunner.output(
            command: "swift",
            arguments: comparisonArguments,
            workingDirectoryURL: packageURL
        )

        FileHandle.standardOutput.write(summary)
    }
}
