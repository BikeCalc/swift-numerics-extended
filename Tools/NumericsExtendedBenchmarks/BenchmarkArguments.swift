// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Foundation

/// The command-line configuration for a benchmark run.
internal struct BenchmarkArguments {
    /// The destination for the encoded report, or `nil` when the report should be printed to standard output.
    internal let outputURL: URL?

    /// Parses the command-line arguments accepted by the benchmark executable.
    ///
    /// - Parameter arguments: The arguments to parse, excluding the executable name.
    /// - Throws: `BenchmarkCommandError.invalidArguments` when the arguments do not match the supported syntax.
    internal init(_ arguments: Array<String>) throws {
        switch arguments.count {
        case 0:
            self.outputURL = nil
        case 2 where arguments[0] == "--output":
            self.outputURL = .init(fileURLWithPath: arguments[1])
        default:
            throw BenchmarkCommandError.invalidArguments
        }
    }
}
