// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

/// The measured timing information for one benchmark operation.
internal struct BenchmarkResult {
    /// The name that identifies the measured operation.
    internal let name: String

    /// The median duration per operation, measured in nanoseconds.
    internal let medianNanosecondsPerOperation: Double

    /// The duration per operation for each measured sample, expressed in nanoseconds.
    internal let samplesNanosecondsPerOperation: Array<Double>

    /// Creates a benchmark result from its measured samples and median.
    ///
    /// - Parameters:
    ///   - name: The name that identifies the measured operation.
    ///   - medianNanosecondsPerOperation: The median duration per operation, measured in nanoseconds.
    ///   - samplesNanosecondsPerOperation: The duration per operation for each sample, expressed in nanoseconds.
    internal init(
        name: String,
        medianNanosecondsPerOperation: Double,
        samplesNanosecondsPerOperation: Array<Double>
    ) {
        self.name = name
        self.medianNanosecondsPerOperation = medianNanosecondsPerOperation
        self.samplesNanosecondsPerOperation = samplesNanosecondsPerOperation
    }
}

// MARK: - Codable

extension BenchmarkResult: Codable {}
