// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

/// A type that supports division.
public protocol Divisible: Equatable {
    /// Returns the reciprocal of this instance.
    var reciprocal: Self? { get }

    /// A boolean value indicating whether this instance is invertible.
    var isInvertible: Bool { get }

    /// Returns a boolean value indicating whether this value is divisible by the specified value.
    ///
    /// - Parameter other: The value to test.
    /// - Returns: `true` if this value is divisible by the specified value, and `false` otherwise.
    func isDivisible(by other: Self) -> Bool

    /// Returns a boolean value indicating whether this value is a factor of the specified value.
    ///
    /// - Parameter other: The value to test.
    /// - Returns: `true` if this value is a factor of the specified value, and `false` otherwise.
    func isFactor(of other: Self) -> Bool

    /// Returns the quotient of dividing the first specified value by the second.
    ///
    /// - Parameters:
    ///   - lhs: The dividend.
    ///   - rhs: The divisor.
    /// - Returns: The quotient.
    static func / (
        _ lhs: Self,
        _ rhs: Self
    ) -> Self

    /// Returns the remainder of dividing the first specified value by the second.
    ///
    /// - Parameters:
    ///   - lhs: The dividend.
    ///   - rhs: The divisor.
    /// - Returns: The remainder.
    static func % (
        _ lhs: Self,
        _ rhs: Self
    ) -> Self

    /// Returns the quotient of dividing this value by the specified value.
    ///
    /// - Parameter divisor: The divisor.
    /// - Returns: The quotient.
    /// - Throws: An error if the conforming type cannot perform the division.
    func dividing(by divisor: Self) throws -> Self
}

extension Divisible {
    /// Returns a boolean value indicating whether this value is a factor of the specified value.
    ///
    /// - Parameter other: The value to test.
    /// - Returns: `true` if the specified value is divisible by this value, and `false` otherwise.
    public func isFactor(of other: Self) -> Bool {
        return other.isDivisible(by: self) == true
    }

    /// Divides the first specified value by the second and stores the quotient in the left-hand-side variable.
    ///
    /// - Parameters:
    ///   - lhs: The dividend.
    ///   - rhs: The divisor.
    public static func /= (
        _ lhs: inout Self,
        _ rhs: Self
    ) {
        let quotient: Self = lhs / rhs
        lhs = quotient
    }

    /// Divides the first specified value by the second and stores the remainder in the left-hand-side variable.
    ///
    /// - Parameters:
    ///   - lhs: The dividend.
    ///   - rhs: The divisor.
    public static func %= (
        _ lhs: inout Self,
        _ rhs: Self
    ) {
        let remainder: Self = lhs % rhs
        lhs = remainder
    }

    /// Returns the quotient of dividing this value by the specified value.
    ///
    /// - Parameter divisor: The divisor.
    /// - Returns: The quotient.
    /// - Throws: An error if the conforming type cannot perform the division.
    public func dividing(by divisor: Self) throws -> Self {
        return self / divisor
    }

    /// Divides this value by the specified value.
    ///
    /// - Parameter divisor: The divisor.
    /// - Throws: An error if the conforming type cannot perform the division.
    public mutating func divide(by divisor: Self) throws {
        self = try self.dividing(by: divisor)
    }
}
