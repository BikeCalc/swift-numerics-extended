// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

/// A type that can compare values by their canonical representation.
public protocol CanonicallyEquatable {
    /// Returns a boolean value indicating whether this value is canonically equal to the specified value.
    ///
    /// - Parameter rhs: The value to compare.
    /// - Returns: `true` if this value is canonically equal to the specified value, and `false` otherwise.
    func isCanonicallyEqual(to rhs: Self) -> Bool
}
