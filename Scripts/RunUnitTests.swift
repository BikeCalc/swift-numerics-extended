// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Foundation

// MARK: - UnitTestRunnerError

/// An error produced while running unit tests or exporting coverage artifacts.
fileprivate enum UnitTestRunnerError {
    /// The script received unsupported command-line arguments.
    case invalidArguments

    /// The coverage report path is empty or does not identify an existing file.
    ///
    /// - Parameter path: The path reported by Swift Package Manager.
    case missingCoverageReport(path: String)

    /// A Swift process could not be started.
    ///
    /// - Parameter underlyingError: The original process-launch error.
    case launchFailed(underlyingError: any Error)

    /// A Swift process exited unsuccessfully.
    ///
    /// - Parameters:
    ///   - arguments: The arguments passed to Swift.
    ///   - status: The process exit status.
    case commandFailed(
        arguments: Array<String>,
        status: Int32
    )

    /// A Swift process was terminated by a signal.
    ///
    /// - Parameter signal: The terminating signal.
    case commandInterrupted(signal: Int32)

    /// Coverage artifacts could not be read or written.
    ///
    /// - Parameter underlyingError: The original file-system error.
    case coverageExportFailed(underlyingError: any Error)

    /// The command-line exit status, preserving an unsuccessful Swift command's status.
    fileprivate var exitStatus: Int32 {
        switch self {
        case .commandFailed(_, let status):
            return status
        default:
            return EXIT_FAILURE
        }
    }
}

// MARK: - CustomStringConvertible

extension UnitTestRunnerError: CustomStringConvertible {
    fileprivate var description: String {
        switch self {
        case .invalidArguments:
            return "Usage: RunUnitTests.swift"
        case .missingCoverageReport(let path):
            return "Code coverage report not found: \(path)"
        case .launchFailed(let underlyingError):
            return "Could not start Swift: \(underlyingError)"
        case .commandFailed(let arguments, let status):
            return "Swift command '\(arguments.joined(separator: " "))' failed with exit status \(status)."
        case .commandInterrupted(let signal):
            return "Swift command was terminated by signal \(signal)."
        case .coverageExportFailed(let underlyingError):
            return "Could not export code coverage: \(underlyingError)"
        }
    }
}

// MARK: - Error

extension UnitTestRunnerError: Error {}

// MARK: - Arguments

/// The command-line arguments accepted by the unit test runner.
fileprivate struct Arguments {
    /// Validates that the script was invoked without options.
    ///
    /// - Parameter arguments: The arguments following the script name.
    /// - Throws: `UnitTestRunnerError.invalidArguments` if any arguments are supplied.
    fileprivate init(_ arguments: Array<String>) throws(UnitTestRunnerError) {
        guard arguments.isEmpty else {
            throw UnitTestRunnerError.invalidArguments
        }
    }
}

// MARK: - UnitTestRunner

/// Runs unit tests and generates coverage artifacts for local use and continuous integration.
fileprivate struct UnitTestRunner {
    /// Creates a unit test runner.
    fileprivate init() {}

    /// The directory containing the exported coverage data and Markdown report.
    private let reportDirectory: URL = .init(
        fileURLWithPath: ".build/code-coverage",
        isDirectory: true
    )

    /// Runs the tests with coverage enabled and prints the generated Markdown report.
    ///
    /// Test output is directed to standard error so standard output contains only the report.
    /// Subprocess failures terminate the script with the same exit status; signals result in a failure status.
    ///
    /// - Throws: `UnitTestRunnerError` if a command fails or coverage artifacts cannot be exported.
    fileprivate func run() throws(UnitTestRunnerError) {
        try self.runSwift(arguments: ["test", "--enable-code-coverage"])

        let pathData: Data = try self.runSwift(
            arguments: ["test", "--show-codecov-path"],
            captureOutput: true
        )
        let reportPath: String = String(decoding: pathData, as: UTF8.self)
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard reportPath.isEmpty == false && FileManager.default.fileExists(atPath: reportPath) else {
            throw UnitTestRunnerError.missingCoverageReport(path: reportPath)
        }

        let coverageData: Data
        do {
            coverageData = try .init(contentsOf: URL(fileURLWithPath: reportPath))
        } catch let error {
            throw UnitTestRunnerError.coverageExportFailed(underlyingError: error)
        }

        let markdown: Data = try self.runSwift(
            arguments: [
                "Scripts/GenerateCodeCoverageReport.swift",
                "--report", reportPath,
                "--sources", "Sources"
            ],
            captureOutput: true
        )

        do {
            try FileManager.default.createDirectory(
                at: self.reportDirectory,
                withIntermediateDirectories: true
            )
            try coverageData.write(
                to: self.reportDirectory.appendingPathComponent("code-coverage.json"),
                options: .atomic
            )
            try markdown.write(
                to: self.reportDirectory.appendingPathComponent("code-coverage.md"),
                options: .atomic
            )
        } catch let error {
            throw UnitTestRunnerError.coverageExportFailed(underlyingError: error)
        }

        FileHandle.standardOutput.write(markdown)
    }

    /// Runs Swift, optionally capturing standard output for the next reporting step.
    ///
    /// - Parameters:
    ///   - arguments: The arguments passed to Swift.
    ///   - captureOutput: Whether to capture standard output instead of forwarding it to standard error.
    /// - Returns: The captured output, or empty data when output is forwarded.
    /// - Throws: `UnitTestRunnerError` if the Swift process cannot start or does not complete successfully.
    @discardableResult
    private func runSwift(
        arguments: Array<String>,
        captureOutput: Bool = false
    ) throws(UnitTestRunnerError) -> Data {
        let output: Pipe? = captureOutput ? .init() : nil
        let process: Process = .init()
        process.executableURL = .init(fileURLWithPath: "/usr/bin/env")
        process.arguments = ["swift"] + arguments
        if let output {
            process.standardOutput = output
        } else {
            process.standardOutput = FileHandle.standardError
        }

        do {
            try process.run()
        } catch let error {
            throw UnitTestRunnerError.launchFailed(underlyingError: error)
        }

        // Drain captured output before waiting so a large report cannot block the subprocess.
        let data: Data = output?.fileHandleForReading.readDataToEndOfFile() ?? .init()
        process.waitUntilExit()

        guard process.terminationReason == .exit else {
            throw UnitTestRunnerError.commandInterrupted(signal: process.terminationStatus)
        }
        guard process.terminationStatus == EXIT_SUCCESS else {
            throw UnitTestRunnerError.commandFailed(
                arguments: arguments,
                status: process.terminationStatus
            )
        }

        return data
    }
}

// MARK: - Unit Test Execution

do throws(UnitTestRunnerError) {
    let _: Arguments = try .init(Array(CommandLine.arguments.dropFirst()))
    let runner: UnitTestRunner = .init()
    try runner.run()
} catch let error {
    FileHandle.standardError.write(Data("\(error)\n".utf8))
    exit(error.exitStatus)
}
