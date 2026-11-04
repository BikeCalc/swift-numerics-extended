// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

/// A type that supports computing a multiplicative inverse.
///
/// The reciprocal may have a different type from the original value. Conforming types determine which values have
/// representable reciprocals, including their behavior for zero and nonfinite values.
public protocol Invertible {
    /// The type used to represent a reciprocal.
    associatedtype Reciprocal

    /// Returns the reciprocal of this instance, or `nil` when no reciprocal is representable.
    var reciprocal: Self.Reciprocal? { get }

    /// A boolean value indicating whether this instance has a representable reciprocal.
    var isInvertible: Bool { get }
}
