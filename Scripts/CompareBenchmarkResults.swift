// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Foundation

// MARK: - Comparison Error

/// An error produced while parsing or comparing benchmark reports.
fileprivate enum ComparisonError {
    /// A report contains more than one result for the same benchmark.
    ///
    /// - Parameters:
    ///   - name: The name shared by the duplicate benchmark results.
    ///   - url: The location of the report containing the duplicate results.
    case duplicateBenchmark(
        name: String,
        url: URL
    )

    /// The baseline and current reports were produced with different configurations.
    ///
    /// - Parameters:
    ///   - baselineURL: The location of the baseline report.
    ///   - currentURL: The location of the current report.
    case incompatibleConfiguration(
        baselineURL: URL,
        currentURL: URL
    )

    /// A report uses an unsupported format version.
    ///
    /// - Parameter url: The location of the report using the unsupported format.
    case incompatibleFormat(url: URL)

    /// The command-line arguments are missing or invalid.
    case invalidArguments
}

// MARK: - CustomStringConvertible

extension ComparisonError: CustomStringConvertible {
    /// A human-readable explanation of the comparison error.
    fileprivate var description: String {
        switch self {
        case .duplicateBenchmark(let name, let url):
            return "Duplicate benchmark '\(name)' in \(url.path)"
        case .incompatibleConfiguration(let baselineURL, let currentURL):
            return "Benchmark configurations differ between \(baselineURL.path) and \(currentURL.path)"
        case .incompatibleFormat(let url):
            return "Unsupported benchmark report format in \(url.path)"
        case .invalidArguments:
            return "Usage: CompareBenchmarkResults.swift [--baseline <path>] --current <path>"
        }
    }
}

// MARK: - Error

extension ComparisonError: Error {}

// MARK: - Arguments

/// The command-line arguments used to locate the benchmark reports.
fileprivate struct Arguments {
    /// The location of the report used as the baseline, if one was provided.
    fileprivate let baselineURL: URL?

    /// The location of the report for the current revision.
    fileprivate let currentURL: URL

    /// Parses the command-line arguments used by the comparison script.
    ///
    /// - Parameter arguments: The arguments following the script name.
    /// - Throws: ``ComparisonError/invalidArguments`` if the arguments do not contain, optionally, one baseline
    ///   report and exactly one current report.
    fileprivate init(_ arguments: Array<String>) throws {
        var baselineURL: URL?
        var currentURL: URL?
        var index: Int = 0

        while index < arguments.count {
            guard index + 1 < arguments.count else {
                throw ComparisonError.invalidArguments
            }

            let url: URL = .init(fileURLWithPath: arguments[index + 1])

            switch arguments[index] {
            case "--baseline" where baselineURL == nil:
                baselineURL = url
            case "--current" where currentURL == nil:
                currentURL = url
            default:
                throw ComparisonError.invalidArguments
            }

            index += 2
        }

        guard let currentURL else {
            throw ComparisonError.invalidArguments
        }

        self.baselineURL = baselineURL
        self.currentURL = currentURL
    }
}

// MARK: - Benchmark Report

/// A decoded benchmark report used in a performance comparison.
fileprivate struct BenchmarkReport {
    /// The version of the benchmark report format.
    fileprivate let formatVersion: Int

    /// The number of benchmark iterations included in each sample.
    fileprivate let iterationsPerSample: Int

    /// The number of measured samples collected for each benchmark.
    fileprivate let measuredSamples: Int

    /// The individual benchmark results contained in the report.
    fileprivate let results: Array<BenchmarkResult>

    /// Creates a benchmark report.
    ///
    /// - Parameters:
    ///   - formatVersion: The version of the benchmark report format.
    ///   - iterationsPerSample: The number of benchmark iterations included in each sample.
    ///   - measuredSamples: The number of measured samples collected for each benchmark.
    ///   - results: The individual benchmark results contained in the report.
    fileprivate init(
        formatVersion: Int,
        iterationsPerSample: Int,
        measuredSamples: Int,
        results: Array<BenchmarkResult>
    ) {
        self.formatVersion = formatVersion
        self.iterationsPerSample = iterationsPerSample
        self.measuredSamples = measuredSamples
        self.results = results
    }
}

// MARK: - Decodable

/// Supports decoding a benchmark report from JSON.
extension BenchmarkReport: Decodable {}

// MARK: - Benchmark Result

/// The measured performance of an individual benchmark.
fileprivate struct BenchmarkResult {
    /// The name of the benchmark.
    fileprivate let name: String

    /// The median duration of one operation, measured in nanoseconds.
    fileprivate let medianNanosecondsPerOperation: Double

    /// Creates an individual benchmark result.
    ///
    /// - Parameters:
    ///   - name: The name of the benchmark.
    ///   - medianNanosecondsPerOperation: The median duration of one operation, measured in nanoseconds.
    fileprivate init(
        name: String,
        medianNanosecondsPerOperation: Double
    ) {
        self.name = name
        self.medianNanosecondsPerOperation = medianNanosecondsPerOperation
    }
}

// MARK: - Decodable

/// Supports decoding an individual benchmark result from JSON.
extension BenchmarkResult: Decodable {}

// MARK: - Benchmark Comparator

/// Produces a Markdown comparison between baseline and current benchmark results.
fileprivate struct BenchmarkComparator {
    /// The baseline median duration for each benchmark, indexed by name, if available.
    private let baseline: Dictionary<String, Double>?

    /// The current median duration for each benchmark, indexed by name.
    private let current: Dictionary<String, Double>

    /// Loads the benchmark reports to compare.
    ///
    /// - Parameters:
    ///   - baselineURL: The location of the report used as the baseline, if available.
    ///   - currentURL: The location of the report for the current revision.
    /// - Throws: An error if a report cannot be loaded or the reports cannot be compared.
    fileprivate init(
        baselineURL: URL?,
        currentURL: URL
    ) throws {
        let baselineReport: BenchmarkReport? = try baselineURL.map { try Self.report(at: $0) }
        let currentReport: BenchmarkReport = try Self.report(at: currentURL)

        if let baselineReport, let baselineURL {
            guard
                baselineReport.iterationsPerSample == currentReport.iterationsPerSample
                    && baselineReport.measuredSamples == currentReport.measuredSamples
            else {
                throw ComparisonError.incompatibleConfiguration(
                    baselineURL: baselineURL,
                    currentURL: currentURL
                )
            }

            self.baseline = try Self.results(
                in: baselineReport,
                at: baselineURL
            )
        } else {
            self.baseline = nil
        }

        self.current = try Self.results(
            in: currentReport,
            at: currentURL
        )
    }

    /// Prints the benchmark comparison as a Markdown table.
    fileprivate func print() {
        Swift.print("## Benchmark performance comparison")
        Swift.print()

        guard let baseline else {
            Swift.print("| Benchmark | Current |")
            Swift.print("|---|---:|")

            for name in self.current.keys.sorted() {
                guard let currentValue = self.current[name] else {
                    continue
                }

                Swift.print("| `\(name)` | \(String(format: "%.2f ns", currentValue)) |")
            }

            return
        }

        Swift.print("| Benchmark | Baseline | Current | Change |")
        Swift.print("|---|---:|---:|---:|")

        for name in Set(baseline.keys).union(self.current.keys).sorted() {
            let baselineValue: Double? = baseline[name]
            let currentValue: Double? = self.current[name]

            switch (baselineValue, currentValue) {
            case (.some(let baselineValue), nil):
                Swift.print("| `\(name)` | \(String(format: "%.2f ns", baselineValue)) | — | Removed |")
            case (nil, .some(let currentValue)):
                Swift.print("| `\(name)` | — | \(String(format: "%.2f ns", currentValue)) | Added |")
            case (.some(let baselineValue), .some(let currentValue)):
                let difference: String

                if baselineValue == 0 {
                    difference = "—"
                } else {
                    let percentage: Double = (currentValue - baselineValue) / baselineValue * 100
                    difference = String(format: "%+.2f%%", percentage)
                }

                Swift.print(
                    "| `\(name)` | \(String(format: "%.2f ns", baselineValue)) | "
                        + "\(String(format: "%.2f ns", currentValue)) | \(difference) |"
                )
            case (nil, nil):
                continue
            }
        }
    }

    /// Loads and decodes a benchmark report.
    ///
    /// - Parameter url: The location of the benchmark report.
    /// - Returns: The decoded benchmark report.
    /// - Throws: An error if the report cannot be read, decoded, or uses an unsupported format.
    private static func report(at url: URL) throws -> BenchmarkReport {
        let data: Data = try .init(contentsOf: url)
        let decoder: JSONDecoder = .init()
        let report: BenchmarkReport = try decoder.decode(
            BenchmarkReport.self,
            from: data
        )

        guard report.formatVersion == 1 else {
            throw ComparisonError.incompatibleFormat(url: url)
        }

        return report
    }

    /// Indexes the results in a benchmark report by name.
    ///
    /// - Parameters:
    ///   - report: The benchmark report whose results to index.
    ///   - url: The location of the report, used to identify it in errors.
    /// - Returns: Each benchmark's median duration, indexed by benchmark name.
    /// - Throws: ``ComparisonError/duplicateBenchmark(name:url:)`` if a benchmark name occurs more than once.
    private static func results(
        in report: BenchmarkReport,
        at url: URL
    ) throws -> Dictionary<String, Double> {
        var results: Dictionary<String, Double> = [:]

        for result in report.results {
            guard results.updateValue(result.medianNanosecondsPerOperation, forKey: result.name) == nil else {
                throw ComparisonError.duplicateBenchmark(name: result.name, url: url)
            }
        }

        return results
    }
}

// MARK: - Comparison

do {
    let arguments: Arguments = try .init(Array(CommandLine.arguments.dropFirst()))
    let comparator: BenchmarkComparator = try .init(
        baselineURL: arguments.baselineURL,
        currentURL: arguments.currentURL
    )

    comparator.print()
} catch let error {
    FileHandle.standardError.write(Data("\(error)\n".utf8))
    exit(EXIT_FAILURE)
}
