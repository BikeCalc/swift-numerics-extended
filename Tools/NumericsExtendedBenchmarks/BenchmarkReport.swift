// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

/// A versioned, serializable report containing the results of one benchmark run.
internal struct BenchmarkReport {
    /// The version of the encoded report schema.
    internal let formatVersion: Int

    /// The number of operation invocations included in each measured sample.
    internal let iterationsPerSample: Int

    /// The number of measured samples collected for each benchmark.
    internal let measuredSamples: Int

    /// The results produced for the measured benchmarks.
    internal let results: Array<BenchmarkResult>

    /// Creates a benchmark report.
    ///
    /// - Parameters:
    ///   - formatVersion: The version of the encoded report schema.
    ///   - iterationsPerSample: The number of operation invocations included in each measured sample.
    ///   - measuredSamples: The number of measured samples collected for each benchmark.
    ///   - results: The results produced for the measured benchmarks.
    internal init(
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

// MARK: - Codable

extension BenchmarkReport: Codable {}
