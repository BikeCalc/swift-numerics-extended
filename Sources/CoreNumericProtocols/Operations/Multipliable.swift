// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

/// A type that supports multiplication.
public protocol Multipliable: Equatable {
    /// Returns a boolean value indicating whether this value is a multiple of the specified value.
    ///
    /// - Parameter other: The value to test.
    /// - Returns: `true` if this value is a multiple of the specified value, and `false` otherwise.
    func isMultiple(of other: Self) -> Bool

    /// Returns the product of multiplying the two specified values.
    ///
    /// - Parameters:
    ///   - lhs: The multiplicand.
    ///   - rhs: The multiplier.
    /// - Returns: The product.
    static func * (
        _ lhs: Self,
        _ rhs: Self
    ) -> Self
}

extension Multipliable {
    /// Multiplies the two specified values and stores the product in the left-hand-side variable.
    ///
    /// - Parameters:
    ///   - lhs: The multiplicand.
    ///   - rhs: The multiplier.
    public static func *= (
        _ lhs: inout Self,
        _ rhs: Self
    ) {
        let product: Self = lhs * rhs
        lhs = product
    }

    /// Returns the product of multiplying this value by the specified value.
    ///
    /// - Parameter multiplier: The multiplier.
    /// - Returns: The product.
    public func multiplying(by multiplier: Self) -> Self {
        return self * multiplier
    }

    /// Multiplies this value by the specified value.
    ///
    /// - Parameter multiplier: The multiplier.
    public mutating func multiply(by multiplier: Self) {
        self *= multiplier
    }
}
