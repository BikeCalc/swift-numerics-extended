// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

/// An error produced while preparing or running benchmarks through the plugin.
internal enum NumericsExtendedBenchmarksPluginError {
    /// A subprocess terminated unsuccessfully.
    ///
    /// - Parameters:
    ///   - command: The executable command that was invoked.
    ///   - status: The termination status returned by the process.
    case commandFailed(
        command: String,
        status: Int
    )

    /// The command-line arguments do not match the supported syntax.
    case invalidArguments

    /// The supported command-line syntax.
    internal static let usage: String = "Usage: swift package plugin benchmark [--baseline <revision>] (default: main)"
}

// MARK: - CustomStringConvertible

extension NumericsExtendedBenchmarksPluginError: CustomStringConvertible {
    internal var description: String {
        switch self {
        case .commandFailed(let command, let status):
            return "Command '\(command)' failed with termination status \(status)"
        case .invalidArguments:
            return Self.usage
        }
    }
}

// MARK: - Error

extension NumericsExtendedBenchmarksPluginError: Error {}
