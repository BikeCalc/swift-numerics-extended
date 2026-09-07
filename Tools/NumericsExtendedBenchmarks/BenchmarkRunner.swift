// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

@available(iOS 16.0, macCatalyst 16.0, macOS 13.0, tvOS 16.0, visionOS 1.0, watchOS 9.0, *)
/// Measures benchmark operations after warming them up and reports their median duration per operation.
internal struct BenchmarkRunner {
    /// The monotonic clock used to measure each sample.
    private let clock: ContinuousClock = .init()

    /// The number of times an operation is invoked in each sample.
    private let iterationsPerSample: Int

    /// The number of timed samples collected for each benchmark.
    private let measuredSamples: Int

    /// The number of untimed samples performed before measurement.
    private let warmupSamples: Int

    /// Creates a benchmark runner with the requested sampling configuration.
    ///
    /// - Parameters:
    ///   - iterationsPerSample: The number of times to invoke an operation in each sample.
    ///   - measuredSamples: The number of timed samples to collect for each benchmark.
    ///   - warmupSamples: The number of untimed samples to perform before measurement.
    internal init(
        iterationsPerSample: Int = 10_000,
        measuredSamples: Int = 10,
        warmupSamples: Int = 1
    ) {
        self.iterationsPerSample = iterationsPerSample
        self.measuredSamples = measuredSamples
        self.warmupSamples = warmupSamples
    }

    /// Measures a collection of benchmarks using the runner's sampling configuration.
    ///
    /// - Parameter benchmarks: The benchmarks to measure.
    /// - Returns: A versioned report containing one result for each benchmark.
    internal func run(_ benchmarks: Array<Benchmark>) -> BenchmarkReport {
        let results: Array<BenchmarkResult> = benchmarks.map(self.run)

        return .init(
            formatVersion: 1,
            iterationsPerSample: self.iterationsPerSample,
            measuredSamples: self.measuredSamples,
            results: results
        )
    }

    /// Warms up and measures a single benchmark.
    ///
    /// - Parameter benchmark: The benchmark to measure.
    /// - Returns: The timing result for the benchmark.
    private func run(_ benchmark: Benchmark) -> BenchmarkResult {
        for _ in 0 ..< self.warmupSamples {
            self.perform(benchmark.operation)
        }

        let samples: Array<Double> = (0 ..< self.measuredSamples).map { _ in
            let duration: Duration = self.clock.measure {
                self.perform(benchmark.operation)
            }

            return duration.nanoseconds / Double(self.iterationsPerSample)
        }

        return .init(
            name: benchmark.name,
            medianNanosecondsPerOperation: self.median(samples),
            samplesNanosecondsPerOperation: samples
        )
    }

    /// Performs one sample of a benchmark operation.
    ///
    /// - Parameter operation: The operation to invoke for every iteration in the sample.
    private func perform(_ operation: @Sendable () -> Void) {
        for _ in 0 ..< self.iterationsPerSample {
            operation()
        }
    }

    /// Calculates the median of a nonempty collection of values.
    ///
    /// - Parameter values: The values whose median should be calculated.
    /// - Returns: The middle value, or the mean of the two middle values when the count is even.
    private func median(_ values: Array<Double>) -> Double {
        let sortedValues: Array<Double> = values.sorted()
        let middleIndex: Int = sortedValues.count / 2

        if sortedValues.count.isMultiple(of: 2) {
            return (sortedValues[middleIndex - 1] + sortedValues[middleIndex]) / 2
        }

        return sortedValues[middleIndex]
    }
}
