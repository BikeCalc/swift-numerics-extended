// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

/// A type that can compare values within absolute and relative tolerances.
///
/// A comparison succeeds when the absolute difference is within either tolerance: a fixed absolute bound or a relative
/// bound scaled by the larger magnitude of the two values. Conformers define the magnitude and difference appropriate
/// to their domain.
///
/// Approximate equality is symmetric but need not be transitive. It must not replace exact equality or be used as the
/// equality relation for hashing. This protocol is independent of `Equatable`.
public protocol ApproximatelyEquatable {
    /// The type used to express an absolute difference.
    associatedtype AbsoluteTolerance

    /// The floating-point type used to express a dimensionless relative difference.
    associatedtype RelativeTolerance: FloatingPoint

    /// Returns whether this value and another agree within either of the specified tolerances.
    ///
    /// The tolerance boundaries are inclusive. Conformers must document how they validate tolerances and handle
    /// exceptional values. Generic callers supply both tolerances explicitly; concrete implementations may provide
    /// defaults or additional overloads.
    ///
    /// - Parameters:
    ///   - other: The value to compare.
    ///   - absoluteTolerance: The nonnegative, finite maximum absolute difference.
    ///   - relativeTolerance: The relative difference allowed, between zero and one inclusive.
    /// - Returns: `true` if the values agree within either tolerance, and `false` otherwise.
    func isApproximatelyEqual(
        to other: Self,
        absoluteTolerance: AbsoluteTolerance,
        relativeTolerance: RelativeTolerance
    ) -> Bool
}
