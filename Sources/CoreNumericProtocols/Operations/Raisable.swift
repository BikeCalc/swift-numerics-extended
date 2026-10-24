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

    /// The type used to represent the result of exponentiation.
    associatedtype Power

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
    ) -> Self.Power

    /// Returns the power of raising this value to the specified value.
    ///
    /// - Parameter exponent: The exponent.
    /// - Returns: The power.
    /// - Throws: An error if the conforming type cannot perform the exponentiation.
    func raising(to exponent: Self.Exponent) throws -> Self.Power
}

extension Raisable {
    /// Returns the power of raising this value to the specified value.
    ///
    /// - Parameter exponent: The exponent.
    /// - Returns: The power.
    /// - Throws: An error if the conforming type cannot perform the exponentiation.
    public func raising(to exponent: Self.Exponent) throws -> Self.Power {
        return self ** exponent
    }
}

extension Raisable
where Self.Power == Self {
    /// Raises the first specified value to the second and stores the power in the left-hand-side variable.
    ///
    /// - Parameters:
    ///   - lhs: The base.
    ///   - rhs: The exponent.
    public static func **= (
        _ lhs: inout Self,
        _ rhs: Self.Exponent
    ) {
        let power: Self.Power = lhs ** rhs
        lhs = power
    }

    /// Raises this value to the specified exponent.
    ///
    /// - Parameter exponent: The exponent.
    /// - Throws: An error if the conforming type cannot perform the exponentiation.
    public mutating func raise(to exponent: Self.Exponent) throws {
        self = try self.raising(to: exponent)
    }
}
