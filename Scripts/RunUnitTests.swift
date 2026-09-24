// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Foundation

/// Runs unit tests and generates coverage artifacts for local use and continuous integration.
fileprivate struct UnitTestRunner {
    /// The directory containing the exported coverage data and Markdown report.
    private let reportDirectory: URL = .init(fileURLWithPath: ".build/code-coverage", isDirectory: true)

    /// Creates a unit test runner.
    fileprivate init() {}

    /// Runs the tests with coverage enabled and prints the generated Markdown report.
    ///
    /// Test output is directed to standard error so standard output contains only the report.
    /// Subprocess failures terminate the script with the same exit status; signals result in a failure status.
    ///
    /// - Throws: An error if a subprocess cannot be launched or coverage artifacts cannot be read or written.
    fileprivate func run() throws {
        guard CommandLine.arguments.count == 1 else {
            FileHandle.standardError.write(Data("Usage: RunUnitTests.swift\n".utf8))
            exit(EXIT_FAILURE)
        }

        try self.runSwift(arguments: ["test", "--enable-code-coverage"])

        let pathData: Data = try self.runSwift(
            arguments: ["test", "--show-codecov-path"],
            captureOutput: true
        )
        let reportPath: String = String(decoding: pathData, as: UTF8.self)
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard reportPath.isEmpty == false && FileManager.default.fileExists(atPath: reportPath) else {
            FileHandle.standardError.write(Data("Code coverage report not found: \(reportPath)\n".utf8))
            exit(EXIT_FAILURE)
        }

        let coverageData: Data = try .init(contentsOf: URL(fileURLWithPath: reportPath))
        let markdown: Data = try self.runSwift(
            arguments: [
                "Scripts/GenerateCodeCoverageReport.swift",
                "--report", reportPath,
                "--sources", "Sources"
            ],
            captureOutput: true
        )

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

        FileHandle.standardOutput.write(markdown)
    }

    /// Runs Swift, optionally capturing standard output for the next reporting step.
    ///
    /// - Parameters:
    ///   - arguments: The arguments passed to Swift.
    ///   - captureOutput: Whether to capture standard output instead of forwarding it to standard error.
    /// - Returns: The captured output, or empty data when output is forwarded.
    /// - Throws: An error if the Swift process cannot be launched.
    @discardableResult
    private func runSwift(
        arguments: Array<String>,
        captureOutput: Bool = false
    ) throws -> Data {
        let output: Pipe? = captureOutput ? .init() : nil
        let process: Process = .init()
        process.executableURL = .init(fileURLWithPath: "/usr/bin/env")
        process.arguments = ["swift"] + arguments
        if let output {
            process.standardOutput = output
        } else {
            process.standardOutput = FileHandle.standardError
        }

        try process.run()
        // Drain captured output before waiting so a large report cannot block the subprocess.
        let data: Data = output?.fileHandleForReading.readDataToEndOfFile() ?? .init()
        process.waitUntilExit()

        guard process.terminationReason == .exit && process.terminationStatus == EXIT_SUCCESS else {
            exit(process.terminationReason == .exit ? process.terminationStatus : EXIT_FAILURE)
        }

        return data
    }
}

do {
    try UnitTestRunner().run()
} catch let error {
    FileHandle.standardError.write(Data("\(error)\n".utf8))
    exit(EXIT_FAILURE)
}
