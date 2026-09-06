// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

/// A type that supports addition.
public protocol Addable: Equatable {
    /// Returns the sum of adding the two specified values.
    ///
    /// - Parameters:
    ///   - lhs: The augend.
    ///   - rhs: The addend.
    /// - Returns: The sum.
    static func + (
        _ lhs: Self,
        _ rhs: Self
    ) -> Self
}

extension Addable {
    /// Adds the two specified values and stores the sum in the left-hand-side variable.
    ///
    /// - Parameters:
    ///   - lhs: The augend.
    ///   - rhs: The addend.
    public static func += (
        _ lhs: inout Self,
        _ rhs: Self
    ) {
        let sum: Self = lhs + rhs
        lhs = sum
    }

    /// Returns the sum of this value and the specified value.
    ///
    /// - Parameter addend: The addend.
    /// - Returns: The sum.
    public func adding(_ addend: Self) -> Self {
        return self + addend
    }

    /// Adds the specified value to this value.
    ///
    /// - Parameter addend: The addend.
    public mutating func add(_ addend: Self) {
        self += addend
    }
}
