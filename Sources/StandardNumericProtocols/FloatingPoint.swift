// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import CoreNumericOperators
import CoreNumericProtocols

extension FloatingPoint
where Self: Decreasable {
    /// Returns this value decreased by the specified percentage.
    ///
    /// - Parameter percentage: The percentage to decrease this value by.
    /// - Returns: The decreased value.
    public func decreasing(by percentage: Self) -> Self {
        return self - self * percentage / 100
    }
}

extension FloatingPoint
where Self: Divisible {
    /// Returns the reciprocal of this instance.
    public var reciprocal: Self? {
        guard self.isInvertible == true else {
            return nil
        }

        return 1 / self
    }

    /// A boolean value indicating whether this instance is invertible.
    public var isInvertible: Bool {
        return self.isZero == false
            && self.isNaN == false
    }

    /// Returns a boolean value indicating whether dividing this value by the specified value produces an exactly zero
    /// floating-point remainder.
    ///
    /// Both values must be finite and the divisor must be nonzero. Because floating-point values are approximate,
    /// values that appear divisible in decimal notation may not produce an exactly zero remainder.
    ///
    /// - Parameter other: The value to test.
    /// - Returns: `true` if dividing this value by the specified value produces an exactly zero remainder, and `false`
    ///   otherwise.
    public func isDivisible(by other: Self) -> Bool {
        guard self.isFinite == true,
            other.isFinite == true,
            other.isZero == false
        else {
            return false
        }

        return (self % other).isZero == true
    }
}

extension FloatingPoint
where Self: Divisible & Multipliable {
    /// Returns a boolean value indicating whether this value is a multiple of the specified value.
    ///
    /// Because floating-point values are approximate, values that appear to be multiples in decimal notation may not
    /// produce an exactly zero remainder.
    ///
    /// - Parameter other: The value to test.
    /// - Returns: `true` if this value produces an exactly zero remainder when divided by the specified value, and
    ///   `false` otherwise.
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

extension FloatingPoint
where Self: Divisible & Negateable & Raisable {
    /// Returns a boolean value indicating whether this value is a power of the specified value.
    ///
    /// A value is a power of a base when raising the base to a positive, zero, or negative integer exponent produces
    /// that value. Floating-point values must match exactly.
    ///
    /// This method treats `1` as a power of every base because an exponent of zero produces `1`. `NaN` is never a
    /// power, while zero and infinity follow floating-point rules.
    ///
    /// - Parameter other: The value to test.
    /// - Returns: `true` if this value is a power of the specified value, and `false` otherwise.
    public func isPower(of other: Self) -> Bool {
        guard self.isNaN == false else {
            return false
        }

        // An exponent of zero makes one a power of every base, including NaN.
        guard self != 1 else {
            return true
        }

        guard other.isNaN == false else {
            return false
        }

        // Handle zero and infinity without entering the iterative search.
        if other.isZero == true || other.isInfinite == true {
            guard self.isZero == true || self.isInfinite == true else {
                return false
            }

            return self.isZero == true || other.sign == .minus || self.sign == .plus
        }

        guard self.isFinite == true, self.isZero == false else {
            return false
        }

        if other.magnitude == 1 {
            return self == other
        }

        guard self.magnitude != 1 else {
            return false
        }

        // Multiply when the value and base magnitudes are on the same side of one; otherwise, search through reciprocal
        // powers.
        let usesPositiveExponent: Bool = (self.magnitude > 1) == (other.magnitude > 1)
        var power: Self = 1

        while true {
            let nextPower: Self = usesPositiveExponent ? power * other : power / other

            guard nextPower != self else {
                return true
            }

            guard nextPower.isFinite == true, nextPower.isZero == false, nextPower != power else {
                return false
            }

            // Stop after passing the target magnitude because subsequent powers continue moving away from it.
            if self.magnitude > 1 {
                guard nextPower.magnitude < self.magnitude else {
                    return false
                }
            } else {
                guard nextPower.magnitude > self.magnitude else {
                    return false
                }
            }

            power = nextPower
        }
    }
}

extension FloatingPoint
where Self: Increasable {
    /// Returns this value increased by the specified percentage.
    ///
    /// - Parameter percentage: The percentage to increase this value by.
    /// - Returns: The increased value.
    public func increasing(by percentage: Self) -> Self {
        return self + self * percentage / 100
    }
}

extension FloatingPoint
where Self: Raisable, Self.Exponent: BinaryInteger {
    /// Returns the power of raising the first specified value to the second.
    ///
    /// A negative exponent returns the reciprocal power.
    ///
    /// - Parameters:
    ///   - lhs: The base.
    ///   - rhs: The exponent.
    /// - Returns: The power.
    public static func ** (
        _ lhs: Self,
        _ rhs: Self.Exponent
    ) -> Self {
        switch rhs {
        case ..<0:
            var result: Self = 1
            var exponent = rhs

            // Count toward zero instead of negating the exponent, which may overflow.
            while exponent < 0 {
                result /= lhs
                exponent += 1
            }

            return result
        case 0:
            return 1
        case 1:
            return lhs
        default:
            var result = lhs
            var exponent: Self.Exponent = 2

            while exponent <= rhs {
                result *= lhs
                exponent += 1
            }

            return result
        }
    }
}

extension FloatingPoint
where Self: Roundable, Self.DecimalPlace: UnsignedInteger {
    /// Returns this instance rounded to the specified approximate decimal precision.
    ///
    /// This operation uses the type's native floating-point representation. Values that cannot be represented exactly
    /// may produce results that differ from exact decimal arithmetic.
    ///
    /// - Parameter decimalPlace: The number of decimal places.
    /// - Returns: This instance rounded.
    public func rounded(to decimalPlace: Self.DecimalPlace) -> Self {
        var divisor: Self = 1
        var remaining = decimalPlace

        while remaining > 0 {
            divisor *= 10
            remaining -= 1
        }

        return (self * divisor).rounded(.toNearestOrAwayFromZero) / divisor
    }
}

extension FloatingPoint
where Self: Truncatable, Self.DecimalPlace: UnsignedInteger {
    /// Returns this instance truncated to the specified approximate decimal precision.
    ///
    /// This operation uses the type's native floating-point representation. Values that cannot be represented exactly
    /// may produce results that differ from exact decimal arithmetic.
    ///
    /// - Parameter decimalPlace: The number of decimal places.
    /// - Returns: This instance truncated.
    public func truncated(to decimalPlace: Self.DecimalPlace) -> Self {
        var divisor: Self = 1
        var remaining = decimalPlace

        while remaining > 0 {
            divisor *= 10
            remaining -= 1
        }

        return (self * divisor).rounded(.towardZero) / divisor
    }
}
