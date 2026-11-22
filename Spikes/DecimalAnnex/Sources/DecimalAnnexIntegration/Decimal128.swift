// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

public import DecimalCore
public import NumericsExtended

// Experimental conformances for the pinned DecimalAnnex revision. Import DecimalCore and NumericsExtended
// alongside this module; this spike does not change the released NumericsExtended product.

@available(anyAppleOS 26.0, *)
extension Decimal128: @retroactive Addable {
    public typealias Addend = Self
    public typealias Sum = Self
}

@available(anyAppleOS 26.0, *)
extension Decimal128: @retroactive Subtractable {
    public typealias Subtrahend = Self
    public typealias Difference = Self
}

@available(anyAppleOS 26.0, *)
extension Decimal128: @retroactive Multipliable {
    public typealias Multiplier = Self
    public typealias Product = Self
}

@available(anyAppleOS 26.0, *)
extension Decimal128: @retroactive Divisible {
    public typealias Divisor = Self
    public typealias Quotient = Self
    public typealias RemainderDivisor = Self
    public typealias Remainder = Self

    /// Returns the remainder using a quotient truncated toward zero.
    public static func % (_ lhs: Self, _ rhs: Self) -> Self {
        return lhs.truncatingRemainder(dividingBy: rhs)
    }
}

@available(anyAppleOS 26.0, *)
extension Decimal128: @retroactive Negateable {}

@available(anyAppleOS 26.0, *)
extension Decimal128: @retroactive Invertible {
    public typealias Reciprocal = Self
}

@available(anyAppleOS 26.0, *)
extension Decimal128: @retroactive Raisable {
    public typealias Power = Self
}

@available(anyAppleOS 26.0, *)
extension Decimal128: @retroactive Increasable {}

@available(anyAppleOS 26.0, *)
extension Decimal128: @retroactive Decreasable {}

@available(anyAppleOS 26.0, *)
extension Decimal128: @retroactive ApproximatelyEquatable {
    public typealias AbsoluteTolerance = Self
    public typealias RelativeTolerance = Self
}

@available(anyAppleOS 26.0, *)
extension Decimal128: @retroactive RepresentableByZero {}

@available(anyAppleOS 26.0, *)
extension Decimal128: @retroactive RepresentableByInfinity {}

@available(anyAppleOS 26.0, *)
extension Decimal128: @retroactive RepresentableByNaN {}

@available(anyAppleOS 26.0, *)
extension Decimal128: @retroactive Roundable {
    public typealias DecimalPlace = UInt

    /// Rounds to the specified number of decimal places, with ties away from zero.
    ///
    /// Values already representable at the requested precision retain their representation.
    /// Nonfinite values are returned unchanged. Rounding status flags are not exposed by this protocol.
    public func rounded(to decimalPlace: UInt) -> Self {
        return adjusted(to: decimalPlace, rounding: .toNearestOrAwayFromZero)
    }
}

@available(anyAppleOS 26.0, *)
extension Decimal128: @retroactive Truncatable {
    /// Truncates to the specified number of decimal places, toward zero.
    ///
    /// Values already representable at the requested precision retain their representation.
    /// Nonfinite values are returned unchanged. Rounding status flags are not exposed by this protocol.
    public func truncated(to decimalPlace: UInt) -> Self {
        return adjusted(to: decimalPlace, rounding: .towardZero)
    }

    private func adjusted(to decimalPlace: UInt, rounding rule: FloatingPointRoundingRule) -> Self {
        // Every finite decimal128 is an integer multiple of 10^-6176. Check before conversion to Int.
        guard isFinite == true, decimalPlace < 6_176 else {
            return self
        }

        let exponent: Int = -Int(decimalPlace)
        guard quantum.exponent < exponent else {
            // Quantizing a large integer to an unnecessarily fine quantum can fail even though no rounding is needed.
            return self
        }

        let precision: Self = .init(sign: .plus, exponent: exponent, significand: 1)
        return quantized(by: precision, rounding: rule)
    }
}
