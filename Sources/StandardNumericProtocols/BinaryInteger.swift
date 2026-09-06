// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import CoreNumericOperators
import CoreNumericProtocols

extension BinaryInteger
where Self: Divisible & RepresentableByZero {
    /// Returns a boolean value indicating whether this value is divisible by the specified value.
    ///
    /// - Parameter other: The value to test.
    /// - Returns: `true` if this value is divisible by the specified value, and `false` otherwise.
    public func isDivisible(by other: Self) -> Bool {
        guard other.isZero == false else {
            return false
        }

        return (self % other).isZero == true
    }
}

extension BinaryInteger
where Self: Divisible {
    /// A boolean value indicating whether this value is even.
    public var isEven: Bool {
        let remainder: Self = self % 2
        return remainder == 0
    }

    /// A boolean value indicating whether this value is odd.
    public var isOdd: Bool {
        let remainder: Self = self % 2
        return remainder != 0
    }
}

extension BinaryInteger
where Self: Multipliable {
    public func isMultiple(of other: Self) -> Bool {
        if self == 0 && other == 0 {
            return true
        }

        guard other != 0 else {
            return false
        }

        return (self % other) == 0
    }
}

extension BinaryInteger
where Self: Divisible & Raisable {
    /// Returns a boolean value indicating whether this value is a power of the specified value.
    ///
    /// A value is a power of a base when repeatedly multiplying the base produces that value. An exponent of zero makes
    /// `1` a power of every base.
    ///
    /// - Parameter other: The value to test.
    /// - Returns: `true` if this value is a power of the specified value, and `false` otherwise.
    public func isPower(of other: Self) -> Bool {
        switch other {
        case 0:
            return self == 0 || self == 1
        case 1:
            return self == 1
        default:
            var number: Self = self

            // Remove one factor of the base at a time until reaching one or finding a remainder.
            while number > 1 && number.isDivisible(by: other) == true {
                let quotient: Self = number / other

                guard quotient != number else {
                    return false
                }

                number = quotient
            }

            return number == 1
        }
    }
}

extension BinaryInteger
where Self: Divisible & Negateable & Raisable {
    /// Returns a boolean value indicating whether this value is a power of the specified value.
    ///
    /// A value is a power of a base when repeatedly multiplying the base produces that value. An exponent of zero makes
    /// `1` a power of every base.
    ///
    /// - Parameter other: The value to test.
    /// - Returns: `true` if this value is a power of the specified value, and `false` otherwise.
    public func isPower(of other: Self) -> Bool {
        switch other {
        case -1:
            return self == 1 || self == -1
        case 0:
            return self == 0 || self == 1
        case 1:
            return self == 1
        default:
            var number: Self = self

            // Remove one factor of the base at a time until reaching one or finding a remainder.
            while number.isDivisible(by: other) == true {
                let quotient: Self = number / other

                guard quotient != number else {
                    return false
                }

                number = quotient

                if number == 1 {
                    return true
                }
            }

            return number == 1
        }
    }
}

extension BinaryInteger
where Self: Raisable, Self.Exponent: BinaryInteger {
    /// Returns the power of raising the first specified value to the second.
    ///
    /// A negative exponent returns `0` for every base except `1` and `-1` because integer division discards the
    /// fractional part. Powers of `1` and `-1` remain exactly representable.
    ///
    /// - Parameters:
    ///   - lhs: The base.
    ///   - rhs: The exponent.
    /// - Precondition: The base must not be zero when the exponent is negative.
    /// - Returns: The power.
    public static func ** (
        _ lhs: Self,
        _ rhs: Self.Exponent
    ) -> Self {
        switch rhs {
        case ..<0:
            precondition(
                lhs != 0,
                "Zero cannot be raised to a negative exponent."
            )

            // Every reciprocal other than one or negative one truncates to zero.
            guard lhs.magnitude == 1 else {
                return 0
            }

            return lhs == 1 || rhs.isMultiple(of: 2) == true ? 1 : lhs
        case 0:
            return 1
        case 1:
            return lhs
        default:
            var result: Self = lhs
            var exponent: Self.Exponent = 2

            while exponent <= rhs {
                result *= lhs
                exponent += 1
            }

            return result
        }
    }
}
