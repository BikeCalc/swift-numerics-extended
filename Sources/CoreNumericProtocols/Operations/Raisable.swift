// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import CoreNumericOperators

/// A type that supports exponentiation.
public protocol Raisable: Equatable {
    /// The type used to represent exponents.
    associatedtype Exponent

    /// Returns a boolean value indicating whether this value is a power of the specified value.
    ///
    /// - Parameter other: The value to test.
    /// - Returns: `true` if this value is a power of the specified value, and `false` otherwise.
    func isPower(of other: Self) -> Bool

    /// Returns the power of raising the first specified value to the second.
    ///
    /// - Parameters:
    ///   - lhs: The base.
    ///   - rhs: The exponent.
    /// - Returns: The power.
    static func ** (
        _ lhs: Self,
        _ rhs: Self.Exponent
    ) -> Self
}

extension Raisable {
    /// Raises the first specified value to the second and stores the power in the left-hand-side variable.
    ///
    /// - Parameters:
    ///   - lhs: The base.
    ///   - rhs: The exponent.
    public static func **= (
        _ lhs: inout Self,
        _ rhs: Self.Exponent
    ) {
        let power: Self = lhs ** rhs
        lhs = power
    }

    /// Returns the power of raising this value to the specified value.
    ///
    /// - Parameter exponent: The exponent.
    /// - Returns: The power.
    public func raising(to exponent: Self.Exponent) -> Self {
        return self ** exponent
    }

    /// Raises this value to the specified exponent.
    ///
    /// - Parameter exponent: The exponent.
    public mutating func raise(to exponent: Self.Exponent) {
        self **= exponent
    }
}
