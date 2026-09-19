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
    /// The command checks tracked and nonignored untracked Swift files, regardless of the selected target.
    ///
    /// - Parameters:
    ///   - context: The package and tools provided by SwiftPM.
    ///   - _: The command-line arguments required by SwiftPM and intentionally ignored by this plugin.
    /// - Throws: An error if Git or Swift Format cannot be launched.
    internal func performCommand(
        context: PluginContext,
        arguments _: Array<String>
    ) async throws {
        let packageURL: URL = context.package.directoryURL
        let swiftFormat: PluginContext.Tool = try context.tool(named: "swift-format")
        let configurationURL: URL = packageURL.appendingPathComponent(".swift-format")
        let output: Pipe = .init()
        let git: Process = .init()
        git.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        git.arguments = ["git", "ls-files", "--cached", "--others", "--exclude-standard", "-z", "--", "*.swift"]
        git.currentDirectoryURL = packageURL
        git.standardOutput = output
        try git.run()
        let data: Data = output.fileHandleForReading.readDataToEndOfFile()
        git.waitUntilExit()

        guard git.terminationReason == .exit && git.terminationStatus == 0 else {
            Diagnostics.error("Git could not enumerate Swift files in the repository.")
            return
        }

        let sourcePaths: Array<String> = Set(
            String(decoding: data, as: UTF8.self)
                .split(separator: "\0")
                .map { packageURL.appendingPathComponent(String($0)).path }
                .filter { FileManager.default.fileExists(atPath: $0) }
        ).sorted()

        guard !sourcePaths.isEmpty else { return }

        let lintArguments: Array<String> =
            ["lint"] + sourcePaths + [
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
