// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Foundation
import PackagePlugin

/// Lints every Swift source file in the Numerics Extended package.
@main
internal struct NumericsExtendedLinterPlugin {}

// MARK: - CommandPlugin

extension NumericsExtendedLinterPlugin: CommandPlugin {
    /// Runs Swift Format with the package's configuration and reports formatting issues as warnings.
    ///
    /// The command always checks the whole package, regardless of the target selected by the invoking IDE.
    ///
    /// - Parameters:
    ///   - context: The package and tools provided by SwiftPM.
    ///   - _: The command-line arguments required by SwiftPM and intentionally ignored by this plugin.
    /// - Throws: An error if Swift Format cannot be launched.
    internal func performCommand(
        context: PluginContext,
        arguments _: Array<String>
    ) async throws {
        let packageURL: URL = context.package.directoryURL
        let swiftFormat: PluginContext.Tool = try context.tool(named: "swift-format")
        let configurationURL: URL = packageURL.appendingPathComponent(".swift-format")
        let additionalURLs: Array<URL> = [
            packageURL.appendingPathComponent("Package.swift"),
            packageURL.appendingPathComponent("Scripts")
        ]
        let targetURLs: Array<URL> = context.package.targets.map(\.directoryURL)
        let sourcePaths: Array<String> = Set((additionalURLs + targetURLs).map(\.path)).sorted()
        let lintArguments: Array<String> =
            ["lint"] + sourcePaths + [
                "--recursive",
                "--parallel",
                "--configuration",
                configurationURL.path
            ]
        let process: Process = try .run(
            swiftFormat.url,
            arguments: lintArguments
        )

        process.waitUntilExit()

        guard process.terminationReason == .exit && process.terminationStatus == 0 else {
            let problem: String = "\(process.terminationReason):\(process.terminationStatus)"

            Diagnostics.error(
                "Swift Format could not complete: \(problem)"
            )
            return
        }
    }
}
