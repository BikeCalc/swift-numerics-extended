// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

/// An error produced while preparing or starting a benchmark run.
internal enum BenchmarkCommandError {
    /// The command-line arguments do not match the supported syntax.
    case invalidArguments

    /// The current platform version does not provide the clock required for measurement.
    case unsupportedPlatform
}

// MARK: - CustomStringConvertible

extension BenchmarkCommandError: CustomStringConvertible {
    internal var description: String {
        switch self {
        case .invalidArguments:
            return "Usage: NumericsExtendedBenchmarks [--output <path>]"
        case .unsupportedPlatform:
            return "ContinuousClock is unavailable on this platform version"
        }
    }
}

// MARK: - Error

extension BenchmarkCommandError: Error {}
