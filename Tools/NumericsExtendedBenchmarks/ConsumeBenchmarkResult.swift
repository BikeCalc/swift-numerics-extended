// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

/// Consumes a benchmark result without adding observable work to the measurement.
///
/// Benchmark results are intentionally not stored or otherwise used. Without this function, release optimizations may
/// determine that producing a result has no observable effect and remove some or all of the operation being measured.
/// The non-inlined function boundary helps prevent the benchmark closure from making that assumption, while
/// `extendLifetime` keeps the value alive through the call without requiring an empty closure.
///
/// - Parameter value: The computed benchmark result to keep alive through the call.
@inline(never)
internal func consumeBenchmarkResult<Value>(_ value: borrowing Value) {
    extendLifetime(value)
}
