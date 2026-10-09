// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

/// A type that supports additive inversion.
public protocol Negateable: Equatable {
    /// Returns the additive inverse of the specified value.
    ///
    /// - Parameter operand: The value to negate.
    /// - Returns: The additive inverse.
    static prefix func - (_ operand: Self) -> Self
}

extension Negateable {
    /// A boolean value indicating whether this value is signed.
    public var isSigned: Bool {
        return true
    }

    /// Returns a boolean value indicating whether this value is the opposite of the specified value.
    ///
    /// - Parameter other: The value to test.
    /// - Returns: `true` if this value is the opposite of the specified value, and `false` otherwise.
    public func isOpposite(of other: Self) -> Bool {
        return self == other.negating()
    }

    /// Returns the additive inverse of this value.
    ///
    /// - Returns: The additive inverse.
    public func negating() -> Self {
        return -self
    }

    /// Replaces this value with its additive inverse.
    public mutating func negate() {
        self = self.negating()
    }
}

extension Negateable
where Self: Comparable & RepresentableByZero {
    /// A boolean value indicating whether this value is negative.
    public var isNegative: Bool {
        return self < Self.zero
    }

    /// A boolean value indicating whether this value is positive.
    public var isPositive: Bool {
        return Self.zero < self
    }
}
