// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

/// The command-line configuration for the benchmark plugin.
internal struct NumericsExtendedBenchmarksPluginArguments {
    /// The Git revision to use as a comparison baseline.
    internal let baselineRevision: String

    /// Whether the plugin should print its usage information without running benchmarks.
    internal let showsHelp: Bool

    /// Parses the command-line arguments accepted by the benchmark plugin.
    ///
    /// - Parameter arguments: The arguments to parse, excluding the plugin verb.
    /// - Throws: `NumericsExtendedBenchmarksPluginError.invalidArguments` when the arguments are unsupported.
    internal init(_ arguments: Array<String>) throws(NumericsExtendedBenchmarksPluginError) {
        if arguments == ["--help"] || arguments == ["-h"] {
            self.baselineRevision = "main"
            self.showsHelp = true
            return
        }

        var baselineRevision: String = "main"
        var baselineWasProvided: Bool = false
        var index: Int = 0

        while index < arguments.count {
            guard index + 1 < arguments.count else {
                throw NumericsExtendedBenchmarksPluginError.invalidArguments
            }

            switch arguments[index] {
            case "--baseline" where baselineWasProvided == false:
                baselineRevision = arguments[index + 1]
                baselineWasProvided = true
            default:
                throw NumericsExtendedBenchmarksPluginError.invalidArguments
            }

            index += 2
        }

        self.baselineRevision = baselineRevision
        self.showsHelp = false
    }
}
