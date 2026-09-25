// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Foundation

// MARK: - BenchmarkRunnerError

/// An error produced while validating inputs or running a command.
fileprivate enum BenchmarkRunnerError {
    /// Unsupported command-line arguments were supplied.
    case invalidArguments

    /// A process could not be started.
    ///
    /// - Parameter underlyingError: The original process-launch error.
    case launchFailed(underlyingError: any Error)

    /// A command exited unsuccessfully.
    ///
    /// - Parameter status: The command's exit status.
    case commandFailed(status: Int32)

    /// A command was terminated by a signal.
    ///
    /// - Parameter signal: The terminating signal.
    case commandInterrupted(signal: Int32)

    /// The selected baseline could not be recovered from origin.
    ///
    /// - Parameter revision: The unavailable revision.
    case unavailableBaseline(revision: String)

    /// The command-line status, preserving unsuccessful subprocess exit codes.
    fileprivate var exitStatus: Int32 {
        switch self {
        case .commandFailed(let status):
            return status
        default:
            return EXIT_FAILURE
        }
    }
}

// MARK: - CustomStringConvertible

extension BenchmarkRunnerError: CustomStringConvertible {
    fileprivate var description: String {
        switch self {
        case .unavailableBaseline(let revision):
            return "error: Benchmark baseline \(revision) is unavailable after fetching from origin."
        case .invalidArguments:
            return "Usage: RunBenchmarks.swift [--baseline <revision>]\n"
                + "Usage: RunBenchmarks.swift --event <event> <base-sha> <before-sha> <ref-name>"
        case .launchFailed(let underlyingError):
            return "Could not start command: \(underlyingError)"
        case .commandFailed(let status):
            return "Command failed with exit status \(status)."
        case .commandInterrupted(let signal):
            return "Command was terminated by signal \(signal)."
        }
    }
}

// MARK: - Error

extension BenchmarkRunnerError: Error {}

// MARK: - Arguments

/// The baseline selection requested locally or by continuous integration.
fileprivate struct Arguments {
    /// A supported way to select the comparison baseline.
    fileprivate enum Selection {
        /// Uses the benchmark plugin's default baseline.
        case automatic

        /// Uses an explicitly supplied revision.
        ///
        /// - Parameter revision: The baseline revision, or an empty string for the plugin default.
        case baseline(revision: String)

        /// Selects a baseline from GitHub Actions event metadata.
        ///
        /// - Parameters:
        ///   - event: The workflow event name.
        ///   - baseSHA: The pull request base commit.
        ///   - beforeSHA: The previous commit for a push.
        ///   - refName: The branch receiving the push.
        case event(
            event: String,
            baseSHA: String,
            beforeSHA: String,
            refName: String
        )
    }

    /// The validated selection to resolve before invoking the plugin.
    fileprivate let selection: Selection

    /// Parses local baseline options or workflow event arguments.
    ///
    /// - Parameter arguments: Arguments following the script name.
    /// - Throws: `BenchmarkRunnerError.invalidArguments` if the argument shape is unsupported.
    fileprivate init(_ arguments: Array<String>) throws(BenchmarkRunnerError) {
        if arguments.isEmpty {
            self.selection = .automatic
        } else if arguments.count == 2 && arguments[0] == "--baseline" {
            self.selection = .baseline(revision: arguments[1])
        } else if arguments.count == 5 && arguments[0] == "--event" {
            self.selection = .event(
                event: arguments[1],
                baseSHA: arguments[2],
                beforeSHA: arguments[3],
                refName: arguments[4]
            )
        } else {
            throw BenchmarkRunnerError.invalidArguments
        }
    }
}

// MARK: - BenchmarkRunner

/// Selects and prepares a baseline before running the benchmark plugin.
fileprivate struct BenchmarkRunner {
    /// The baseline selection supplied by the caller.
    private let arguments: Arguments

    /// Creates a runner for the validated baseline selection.
    ///
    /// - Parameter arguments: The local options or workflow metadata.
    fileprivate init(arguments: Arguments) {
        self.arguments = arguments
    }

    /// Runs the benchmark plugin using the script's command-line arguments.
    ///
    /// Preserves the plugin's failure status, or reports a failure when baseline preparation fails.
    ///
    /// - Throws: `BenchmarkRunnerError` if a command cannot start, a baseline is unavailable, or the plugin fails.
    fileprivate func run() throws(BenchmarkRunnerError) {
        let baselineSHA: String = try self.selectBaseline()
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

        do {
            try process.run()
        } catch let error {
            throw BenchmarkRunnerError.launchFailed(underlyingError: error)
        }
        process.waitUntilExit()

        // Preserve the plugin's exit status and treat signal termination as failure.
        guard process.terminationReason == .exit else {
            throw BenchmarkRunnerError.commandInterrupted(signal: process.terminationStatus)
        }
        guard process.terminationStatus == EXIT_SUCCESS else {
            throw BenchmarkRunnerError.commandFailed(status: process.terminationStatus)
        }
    }

    /// Resolves the validated selection to a baseline commit.
    ///
    /// - Returns: The baseline revision, or an empty string for the plugin default.
    /// - Throws: `BenchmarkRunnerError` if Git cannot resolve the release-branch baseline.
    private func selectBaseline() throws(BenchmarkRunnerError) -> String {
        switch self.arguments.selection {
        case .automatic:
            return ""
        case .baseline(let revision):
            return revision
        case .event(let event, let baseSHA, let beforeSHA, let refName):
            if event == "pull_request" {
                return baseSHA
            }

            if event == "push" && refName == "main" && beforeSHA.allSatisfy({ return $0 == "0" }) == false {
                return beforeSHA
            }

            if event == "push" && refName.hasPrefix("release/") {
                let output: Pipe = .init()
                let git: Process = .init()
                git.executableURL = .init(fileURLWithPath: "/usr/bin/env")
                git.arguments = ["git", "rev-parse", "refs/remotes/origin/main"]
                git.standardOutput = output

                do {
                    try git.run()
                } catch let error {
                    throw BenchmarkRunnerError.launchFailed(underlyingError: error)
                }
                let data: Data = output.fileHandleForReading.readDataToEndOfFile()
                git.waitUntilExit()

                guard git.terminationReason == .exit && git.terminationStatus == EXIT_SUCCESS else {
                    if git.terminationReason != .exit {
                        throw BenchmarkRunnerError.commandInterrupted(signal: git.terminationStatus)
                    }
                    throw BenchmarkRunnerError.commandFailed(status: git.terminationStatus)
                }

                // Capture Git's revision instead of including it in the benchmark report on standard output.
                return String(decoding: data, as: UTF8.self).trimmingCharacters(in: .newlines)
            }

            return ""
        }
    }

    /// Checks that a baseline commit is available locally, fetching it from origin when necessary.
    ///
    /// A push event can reference a previous commit that was replaced by an amend or force push. Even a full checkout
    /// may omit that commit because it is no longer reachable from the remote branches or tags. Fetching the selected
    /// revision explicitly can recover it while origin still makes it available.
    ///
    /// Throws a validation error if fetching fails or the selected revision still cannot be resolved to a commit.
    /// This prevents the benchmark comparison from silently using a different baseline or skipping the comparison.
    ///
    /// - Parameter revision: The selected baseline revision.
    /// - Throws: `BenchmarkRunnerError` if Git cannot start or the baseline cannot be prepared.
    private func prepareBaseline(_ revision: String) throws(BenchmarkRunnerError) {
        /// Runs Git with diagnostics directed to standard error rather than the Markdown report.
        ///
        /// - Parameters:
        ///   - arguments: Git's command and arguments.
        ///   - quiet: Whether to suppress output from an availability check.
        /// - Returns: Whether Git completed successfully.
        /// - Throws: `BenchmarkRunnerError.launchFailed` if Git cannot start.
        func runGit(
            _ arguments: Array<String>,
            quiet: Bool = false
        ) throws(BenchmarkRunnerError) -> Bool {
            let process: Process = .init()
            process.executableURL = .init(fileURLWithPath: "/usr/bin/env")
            process.arguments = ["git"] + arguments
            process.standardOutput = quiet ? FileHandle.nullDevice : FileHandle.standardError
            process.standardError = quiet ? FileHandle.nullDevice : FileHandle.standardError
            do {
                try process.run()
            } catch let error {
                throw BenchmarkRunnerError.launchFailed(underlyingError: error)
            }
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
        // First retrieve the missing revision, then verify that the exact revision passed to the plugin resolves
        // locally.
        // Fetch success alone does not guarantee that the requested revision name is resolvable in this checkout.
        // The guard evaluates these checks in order and skips verification if fetching fails; both must succeed.
        guard try runGit(["fetch", "--no-tags", "origin", revision]),
            try runGit(checkArguments, quiet: true)
        else {
            throw BenchmarkRunnerError.unavailableBaseline(revision: revision)
        }
    }
}

// MARK: - Benchmark Execution

do throws(BenchmarkRunnerError) {
    let arguments: Arguments = try .init(Array(CommandLine.arguments.dropFirst()))
    let runner: BenchmarkRunner = .init(arguments: arguments)
    try runner.run()
} catch let error {
    FileHandle.standardError.write(Data("\(error)\n".utf8))
    exit(error.exitStatus)
}
