// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Foundation

// MARK: - CodeCoverageReportError

/// An error produced while generating a code coverage report.
fileprivate enum CodeCoverageReportError {
    /// A report could not be read from disk.
    ///
    /// - Parameters:
    ///   - url: The location of the report.
    ///   - underlyingError: The original file-reading error.
    case reportReadFailed(
        url: URL,
        underlyingError: any Error
    )

    /// A report could not be decoded from JSON.
    ///
    /// - Parameters:
    ///   - url: The location of the report.
    ///   - underlyingError: The original decoding error.
    case reportDecodingFailed(
        url: URL,
        underlyingError: any Error
    )

    /// The command-line arguments are missing or invalid.
    case invalidArguments

    /// The report contains no coverage for files in the source directory.
    ///
    /// - Parameter url: The source directory that has no coverage.
    case noSourceCoverage(url: URL)
}

// MARK: - CustomStringConvertible

extension CodeCoverageReportError: CustomStringConvertible {
    fileprivate var description: String {
        switch self {
        case .reportReadFailed(let url, let underlyingError):
            return "Could not read report at \(url.path): \(underlyingError)"
        case .reportDecodingFailed(let url, let underlyingError):
            return "Could not decode report at \(url.path): \(underlyingError)"
        case .invalidArguments:
            return "Usage: GenerateCodeCoverageReport.swift --report <path> --sources <path>"
        case .noSourceCoverage(let url):
            return "No code coverage found for sources in \(url.path)"
        }
    }
}

// MARK: - Error

extension CodeCoverageReportError: Error {}

// MARK: - Arguments

/// The command-line arguments used to locate the code coverage report and package sources.
fileprivate struct Arguments {
    /// The location of the LLVM code coverage report.
    fileprivate let reportURL: URL

    /// The location of the package's source directory.
    fileprivate let sourcesURL: URL

    /// Parses the command-line arguments used by the report generator.
    ///
    /// - Parameter arguments: The arguments following the script name.
    /// - Throws: `CodeCoverageReportError.invalidArguments` if the arguments do not contain one report and one
    ///   source directory.
    fileprivate init(_ arguments: Array<String>) throws(CodeCoverageReportError) {
        var reportURL: URL?
        var sourcesURL: URL?
        var index: Int = 0

        while index < arguments.count {
            guard index + 1 < arguments.count else {
                throw CodeCoverageReportError.invalidArguments
            }

            let url: URL = .init(fileURLWithPath: arguments[index + 1])

            switch arguments[index] {
            case "--report" where reportURL == nil:
                reportURL = url
            case "--sources" where sourcesURL == nil:
                sourcesURL = url
            default:
                throw CodeCoverageReportError.invalidArguments
            }

            index += 2
        }

        guard let reportURL, let sourcesURL else {
            throw CodeCoverageReportError.invalidArguments
        }

        self.reportURL = reportURL
        self.sourcesURL = sourcesURL
    }
}

// MARK: - CodeCoverageReport

/// An LLVM code coverage export.
fileprivate struct CodeCoverageReport {
    /// The collections of code coverage results in the export.
    fileprivate let data: Array<CodeCoverageData>

    /// Creates a code coverage report.
    ///
    /// - Parameter data: The collections of code coverage results in the export.
    fileprivate init(data: Array<CodeCoverageData>) {
        self.data = data
    }
}

// MARK: - Decodable

/// Supports decoding an LLVM code coverage export.
extension CodeCoverageReport: Decodable {}

// MARK: - CodeCoverageData

/// A collection of file coverage results in an LLVM code coverage export.
fileprivate struct CodeCoverageData {
    /// The coverage results for individual files.
    fileprivate let files: Array<CodeCoverageFile>

    /// Creates a collection of file coverage results.
    ///
    /// - Parameter files: The coverage results for individual files.
    fileprivate init(files: Array<CodeCoverageFile>) {
        self.files = files
    }
}

// MARK: - Decodable

/// Supports decoding a collection of LLVM code coverage results.
extension CodeCoverageData: Decodable {}

// MARK: - CodeCoverageFile

/// The code coverage result for one file.
fileprivate struct CodeCoverageFile {
    /// The absolute path of the covered file.
    fileprivate let filename: String

    /// The coverage summary for the file.
    fileprivate let summary: CodeCoverageSummary

    /// Creates a code coverage result for one file.
    ///
    /// - Parameters:
    ///   - filename: The absolute path of the covered file.
    ///   - summary: The coverage summary for the file.
    fileprivate init(
        filename: String,
        summary: CodeCoverageSummary
    ) {
        self.filename = filename
        self.summary = summary
    }
}

// MARK: - Decodable

/// Supports decoding the code coverage result for one file.
extension CodeCoverageFile: Decodable {}

// MARK: - CodeCoverageSummary

/// The LLVM coverage metrics for one scope.
fileprivate struct CodeCoverageSummary {
    /// The function coverage metric.
    fileprivate let functions: CodeCoverageMetric

    /// The line coverage metric.
    fileprivate let lines: CodeCoverageMetric

    /// The region coverage metric.
    fileprivate let regions: CodeCoverageMetric

    /// Creates a coverage summary for one scope.
    ///
    /// - Parameters:
    ///   - functions: The function coverage metric.
    ///   - lines: The line coverage metric.
    ///   - regions: The region coverage metric.
    fileprivate init(
        functions: CodeCoverageMetric,
        lines: CodeCoverageMetric,
        regions: CodeCoverageMetric
    ) {
        self.functions = functions
        self.lines = lines
        self.regions = regions
    }
}

// MARK: - Decodable

/// Supports decoding LLVM coverage metrics for one scope.
extension CodeCoverageSummary: Decodable {}

// MARK: - CodeCoverageMetric

/// The covered and total items reported for one LLVM coverage metric.
fileprivate struct CodeCoverageMetric {
    /// The total number of items included in the metric.
    fileprivate let count: Int

    /// The number of covered items included in the metric.
    fileprivate let covered: Int

    /// Creates an LLVM code coverage metric.
    ///
    /// - Parameters:
    ///   - count: The total number of items included in the metric.
    ///   - covered: The number of covered items included in the metric.
    fileprivate init(
        count: Int,
        covered: Int
    ) {
        self.count = count
        self.covered = covered
    }

    /// A metric with no covered or total items.
    fileprivate static let zero: Self = .init(
        count: 0,
        covered: 0
    )

    /// Adds another metric to this metric.
    ///
    /// - Parameter other: The metric to add.
    fileprivate mutating func add(_ other: Self) {
        self = .init(
            count: self.count + other.count,
            covered: self.covered + other.covered
        )
    }
}

// MARK: - Decodable

/// Supports decoding one LLVM coverage metric.
extension CodeCoverageMetric: Decodable {}

// MARK: - CodeCoverageTotals

/// The aggregated LLVM coverage metrics for one scope.
fileprivate struct CodeCoverageTotals {
    /// The aggregated function coverage metric.
    fileprivate var functions: CodeCoverageMetric

    /// The aggregated line coverage metric.
    fileprivate var lines: CodeCoverageMetric

    /// The aggregated region coverage metric.
    fileprivate var regions: CodeCoverageMetric

    /// Creates aggregated coverage totals, defaulting each metric to zero.
    ///
    /// - Parameters:
    ///   - functions: The initial aggregated function coverage metric.
    ///   - lines: The initial aggregated line coverage metric.
    ///   - regions: The initial aggregated region coverage metric.
    fileprivate init(
        functions: CodeCoverageMetric = .zero,
        lines: CodeCoverageMetric = .zero,
        regions: CodeCoverageMetric = .zero
    ) {
        self.functions = functions
        self.lines = lines
        self.regions = regions
    }

    /// Adds a file's coverage summary to these totals.
    ///
    /// - Parameter summary: The coverage summary to add.
    fileprivate mutating func add(_ summary: CodeCoverageSummary) {
        self.functions.add(summary.functions)
        self.lines.add(summary.lines)
        self.regions.add(summary.regions)
    }
}

// MARK: - SourceCodeCoverage

/// The code coverage result for one package source file.
fileprivate struct SourceCodeCoverage {
    /// The path of the source file relative to the package's source directory.
    fileprivate let path: String

    /// The LLVM coverage metrics for the source file.
    fileprivate let summary: CodeCoverageSummary

    /// Creates a coverage result for one package source file.
    ///
    /// - Parameters:
    ///   - path: The source file's path relative to the package's source directory.
    ///   - summary: The coverage metrics for the source file.
    fileprivate init(
        path: String,
        summary: CodeCoverageSummary
    ) {
        self.path = path
        self.summary = summary
    }
}

// MARK: - CodeCoverageReporter

/// Produces a Markdown report from an LLVM code coverage export.
fileprivate struct CodeCoverageReporter {
    /// The package source coverage results included in the report.
    private let files: Array<SourceCodeCoverage>

    /// Loads the LLVM report and selects coverage belonging to the package's source directory.
    ///
    /// - Parameters:
    ///   - reportURL: The location of the LLVM code coverage report.
    ///   - sourcesURL: The location of the package's source directory.
    /// - Throws: `CodeCoverageReportError` if the report cannot be read, decoded, or does not contain
    ///   package source coverage.
    fileprivate init(
        reportURL: URL,
        sourcesURL: URL
    ) throws(CodeCoverageReportError) {
        let reportData: Data

        do {
            reportData = try .init(contentsOf: reportURL)
        } catch let error {
            throw CodeCoverageReportError.reportReadFailed(
                url: reportURL,
                underlyingError: error
            )
        }

        let decoder: JSONDecoder = .init()
        let report: CodeCoverageReport

        do {
            report = try decoder.decode(
                CodeCoverageReport.self,
                from: reportData
            )
        } catch let error {
            throw CodeCoverageReportError.reportDecodingFailed(
                url: reportURL,
                underlyingError: error
            )
        }
        let standardizedSourcesURL: URL = sourcesURL.standardizedFileURL
        let sourcePathPrefix: String = standardizedSourcesURL.path + "/"

        // LLVM exports coverage for dependencies and generated files alongside package sources. Retain only files
        // located beneath the explicitly selected source directory.
        self.files = report.data
            .flatMap(\.files)
            .compactMap { file -> SourceCodeCoverage? in
                let fileURL: URL = URL(fileURLWithPath: file.filename).standardizedFileURL

                guard fileURL.path.hasPrefix(sourcePathPrefix) else {
                    return nil
                }

                return .init(
                    path: String(fileURL.path.dropFirst(sourcePathPrefix.count)),
                    summary: file.summary
                )
            }
            .sorted { lhs, rhs in
                return lhs.path < rhs.path
            }

        guard self.files.isEmpty == false else {
            throw CodeCoverageReportError.noSourceCoverage(url: standardizedSourcesURL)
        }
    }

    /// Prints the package's LLVM code coverage as Markdown.
    fileprivate func printReport() {
        print("## Code Coverage")
        print()

        self.printTargets()
        print()
        self.printFiles()
    }

    /// Prints coverage aggregated by package target.
    private func printTargets() {
        var targets: Dictionary<String, CodeCoverageTotals> = [:]
        var package: CodeCoverageTotals = .init()

        // A source path begins with its SwiftPM target directory, which provides a stable aggregation key without
        // coupling the script to the package manifest.
        for file in self.files {
            guard let target: Substring = file.path.split(separator: "/").first else {
                continue
            }

            targets[String(target), default: .init()].add(file.summary)
            package.add(file.summary)
        }

        print("| Target | Lines | Functions | Regions |")
        print("|---|---:|---:|---:|")

        for target in targets.keys.sorted() {
            guard let totals: CodeCoverageTotals = targets[target] else {
                continue
            }

            print(
                "| `\(target)` | \(Self.format(totals.lines)) | \(Self.format(totals.functions)) | "
                    + "\(Self.format(totals.regions)) |"
            )
        }

        print(
            "| **Package** | **\(Self.format(package.lines))** | **\(Self.format(package.functions))** | "
                + "**\(Self.format(package.regions))** |"
        )
    }

    /// Prints coverage for each package source file.
    private func printFiles() {
        print("| Source File | Lines | Functions | Regions |")
        print("|---|---:|---:|---:|")

        for file in self.files {
            print(
                "| `\(file.path)` | \(Self.format(file.summary.lines)) | "
                    + "\(Self.format(file.summary.functions)) | \(Self.format(file.summary.regions)) |"
            )
        }
    }

    /// Formats one LLVM coverage metric for a Markdown table.
    ///
    /// - Parameter metric: The metric to format.
    /// - Returns: The covered count, total count, and percentage.
    private static func format(_ metric: CodeCoverageMetric) -> String {
        let percentage: Double

        if metric.count == 0 {
            percentage = 0
        } else {
            percentage = Double(metric.covered) / Double(metric.count) * 100
        }

        return "\(self.format(metric.covered))/\(self.format(metric.count)) "
            + "(\(String(format: "%.2f%%", percentage)))"
    }

    /// Formats an integer using the project's numeric formatting convention.
    ///
    /// - Parameter value: The integer to format.
    /// - Returns: The integer with comma-separated thousands.
    private static func format(_ value: Int) -> String {
        let formatter: NumberFormatter = .init()
        formatter.locale = .init(identifier: "en_US_POSIX")
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = true
        formatter.maximumFractionDigits = 0

        return formatter.string(from: NSNumber(value: value)) ?? String(value)
    }
}

// MARK: - Report Generation

do {
    let arguments: Arguments = try .init(Array(CommandLine.arguments.dropFirst()))
    let reporter: CodeCoverageReporter = try .init(
        reportURL: arguments.reportURL,
        sourcesURL: arguments.sourcesURL
    )

    reporter.printReport()
} catch let error {
    FileHandle.standardError.write(Data("\(error)\n".utf8))
    exit(EXIT_FAILURE)
}
