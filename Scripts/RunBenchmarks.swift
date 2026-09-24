// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Foundation

/// Selects and prepares a baseline before running the benchmark plugin.
fileprivate struct BenchmarkRunner {
    /// Creates a benchmark runner.
    fileprivate init() {}

    /// Runs the benchmark plugin using the script's command-line arguments.
    ///
    /// Exits with the plugin's status, or a failure status when baseline preparation fails.
    ///
    /// - Throws: An error if Git or the Swift process cannot be launched.
    fileprivate func run() throws {
        let arguments: Array<String> = Array(CommandLine.arguments.dropFirst())
        let baselineSHA: String = try self.selectBaseline(from: arguments)
        if baselineSHA.isEmpty == false {
            try self.prepareBaseline(baselineSHA)
        }

        let process: Process = .init()
        process.executableURL = .init(fileURLWithPath: "/usr/bin/env")
        process.arguments = [
            "swift", "package", "plugin", "--allow-network-connections", "all", "benchmark"
        ]

        // An omitted or empty baseline leaves the plugin's default baseline in effect.
        if baselineSHA.isEmpty == false {
            process.arguments?.append(contentsOf: ["--baseline", baselineSHA])
        }

        try process.run()
        process.waitUntilExit()

        // Preserve the plugin's exit status and treat signal termination as failure.
        exit(process.terminationReason == .exit ? process.terminationStatus : EXIT_FAILURE)
    }

    /// Selects the benchmark baseline from an explicit revision or workflow event arguments.
    ///
    /// - Parameter arguments: No arguments, `--baseline <revision>`, or
    ///   `--event <event> <base-sha> <before-sha> <ref-name>`.
    /// - Returns: The baseline revision, or an empty string when no comparison applies.
    /// - Throws: An error if Git cannot be launched to resolve the release-branch baseline.
    private func selectBaseline(from arguments: Array<String>) throws -> String {
        if arguments.isEmpty {
            return ""
        }

        if arguments.count == 2 && arguments[0] == "--baseline" {
            return arguments[1]
        }

        guard arguments.count == 5 && arguments[0] == "--event" else {
            let data: Data = .init(
                ("Usage: RunBenchmarks.swift [--baseline <revision>]\n"
                    + "Usage: RunBenchmarks.swift --event <event> <base-sha> <before-sha> <ref-name>\n").utf8
            )
            FileHandle.standardError.write(data)
            exit(EXIT_FAILURE)
        }

        let event: String = arguments[1]
        let baseSHA: String = arguments[2]
        let beforeSHA: String = arguments[3]
        let refName: String = arguments[4]

        if event == "pull_request" {
            return baseSHA
        }

        if event == "push" && refName == "main" && beforeSHA.allSatisfy({ $0 == "0" }) == false {
            return beforeSHA
        }

        if event == "push" && refName.hasPrefix("release/") {
            let output: Pipe = .init()
            let git: Process = .init()
            git.executableURL = .init(fileURLWithPath: "/usr/bin/env")
            git.arguments = ["git", "rev-parse", "refs/remotes/origin/main"]
            git.standardOutput = output

            try git.run()
            let data: Data = output.fileHandleForReading.readDataToEndOfFile()
            git.waitUntilExit()

            guard git.terminationReason == .exit && git.terminationStatus == EXIT_SUCCESS else {
                exit(git.terminationReason == .exit ? git.terminationStatus : EXIT_FAILURE)
            }

            // Capture Git's revision instead of including it in the benchmark report on standard output.
            return String(decoding: data, as: UTF8.self).trimmingCharacters(in: .newlines)
        }

        return ""
    }

    /// Checks that a baseline commit is available locally, fetching it from origin when necessary.
    ///
    /// A push event can reference a previous commit that was replaced by an amend or force push. Even a full checkout
    /// may omit that commit because it is no longer reachable from the remote branches or tags. Fetching the selected
    /// revision explicitly can recover it while origin still makes it available.
    ///
    /// Exits with a failure diagnostic if fetching fails or the selected revision still cannot be resolved to a commit.
    /// This prevents the benchmark comparison from silently using a different baseline or skipping the comparison.
    ///
    /// - Parameter revision: The selected baseline revision.
    /// - Throws: An error if Git cannot be launched.
    private func prepareBaseline(_ revision: String) throws {
        /// Runs Git with diagnostics directed to standard error rather than the Markdown report.
        ///
        /// - Parameters:
        ///   - arguments: Git's command and arguments.
        ///   - quiet: Whether to suppress output from an availability check.
        /// - Returns: Whether Git completed successfully.
        /// - Throws: An error if Git cannot be launched.
        func runGit(
            _ arguments: Array<String>,
            quiet: Bool = false
        ) throws -> Bool {
            let process: Process = .init()
            process.executableURL = .init(fileURLWithPath: "/usr/bin/env")
            process.arguments = ["git"] + arguments
            process.standardOutput = quiet ? FileHandle.nullDevice : FileHandle.standardError
            process.standardError = quiet ? FileHandle.nullDevice : FileHandle.standardError
            try process.run()
            process.waitUntilExit()
            return process.terminationReason == .exit && process.terminationStatus == EXIT_SUCCESS
        }

        // Require a commit, not merely an existing Git object. A missing revision is expected here, so suppress Git's
        // initial error while deciding whether recovery is needed.
        let checkArguments: Array<String> = ["rev-parse", "--verify", "--end-of-options", "\(revision)^{commit}"]
        if try runGit(checkArguments, quiet: true) {
            return
        }

        FileHandle.standardError.write(Data("Fetching missing benchmark baseline \(revision) from origin.\n".utf8))
        // First retrieve the missing revision, then verify that the exact revision passed to the plugin resolves locally.
        // Fetch success alone does not guarantee that the requested revision name is resolvable in this checkout.
        // The guard evaluates these checks in order and skips verification if fetching fails; both must succeed.
        guard try runGit(["fetch", "--no-tags", "origin", revision]),
            try runGit(checkArguments, quiet: true)
        else {
            FileHandle.standardError.write(
                Data("error: Benchmark baseline \(revision) is unavailable after fetching from origin.\n".utf8)
            )
            exit(EXIT_FAILURE)
        }
    }
}

do {
    try BenchmarkRunner().run()
} catch let error {
    FileHandle.standardError.write(Data("\(error)\n".utf8))
    exit(EXIT_FAILURE)
}
