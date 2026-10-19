// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

/// An error produced while locating or launching the linter tools.
internal enum NumericsExtendedLinterPluginError {
    /// A required tool could not be located or launched.
    ///
    /// - Parameter error: The original tool lookup or process-launch failure.
    case operationFailed(error: any Error)
}

// MARK: - CustomStringConvertible

extension NumericsExtendedLinterPluginError: CustomStringConvertible {
    internal var description: String {
        switch self {
        case .operationFailed(let error):
            return "Could not run the linter: \(error)"
        }
    }
}

// MARK: - Error

extension NumericsExtendedLinterPluginError: Error {}
