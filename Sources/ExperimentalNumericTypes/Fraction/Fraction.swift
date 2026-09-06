// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import CoreNumericOperators
import CoreNumericProtocols
import ExperimentalNumericProtocols
import StandardNumericProtocols
import StandardNumericTypes

/// An extended rational number represented by a numerator and denominator.
///
/// `Fraction` stores a ratio of binary integers without converting finite values to binary floating point. For finite
/// values, the numerator and denominator are preserved as supplied so that distinct representations of the same
/// canonical value remain distinct Swift values. Infinite values are stored canonically as `1/0` or `-1/0`.
///
/// For example:
///
/// ```swift
/// let value = Fraction<Int>(2, 4)
///
/// print(value)
/// // Prints "2/4"
/// ```
///
/// Create whole values with integer literals and perform exact arithmetic with other rational values.
///
/// For example:
///
/// ```swift
/// let oneHalf = Fraction<Int>(1, 2)
/// let oneThird = Fraction<Int>(1, 3)
/// let one: Fraction<Int> = 1
///
/// print(oneHalf + oneThird)
/// // Prints "5/6"
/// print(one / oneHalf)
/// // Prints "2/1"
/// ```
///
/// Use `Canonicalized` when storage should always use the canonical representation.
/// Canonicalization removes common factors and stores any negative sign in the numerator.
///
/// For example:
///
/// ```swift
/// @Canonicalized var value: Fraction<Int> = .init(2, -4)
///
/// print(value)
/// // Prints "-1/2"
/// ```
///
/// The term type determines which signs and magnitudes can be represented. A signed term type supports negative finite
/// values, negative zero, and negative infinity. An unsigned term type supports only nonnegative terms; operations that
/// require an unrepresentable negative finite result can trap, while an unrepresentable negative infinity produces NaN.
///
/// A zero denominator represents a nonfinite value. A nonzero numerator over zero is infinity, while `0/0` is NaN.
/// Arithmetic propagates these values without trapping for division by zero. Finite arithmetic can still trap when an
/// intermediate or result cannot be represented by `Term`.
///
/// - Note: `Fraction` is intentionally experimental. Its API may evolve across major releases.
public struct Fraction<Term>
where Term: BinaryInteger {
    /// The keys used to encode and decode a fraction.
    private enum CodingKeys: String, CodingKey {
        case numerator = "num"
        case denominator = "den"
    }

    /// The numerator of this value.
    public let numerator: Term

    /// The denominator of this value.
    public let denominator: Term

    /// Creates a rational value with the specified numerator and denominator.
    ///
    /// Finite terms are stored as supplied, including zero numerators. A nonzero numerator with a zero denominator is
    /// stored canonically as `1/0` or `-1/0`. The representation `0/0` is stored unchanged as NaN.
    ///
    /// - Parameter numerator: The numerator.
    /// - Parameter denominator: The denominator. Zero creates infinity or NaN.
    public init(
        _ numerator: Term,
        _ denominator: Term
    ) {
        if denominator != 0 || numerator == 0 {
            self.numerator = numerator
            self.denominator = denominator
        } else if numerator < 0 {
            self.numerator = 0 - 1
            self.denominator = 0
        } else {
            self.numerator = 1
            self.denominator = 0
        }
    }

    /// A boolean value indicating whether this value carries a negative sign.
    private var hasNegativeSign: Bool {
        if self.isInfinite {
            return self.numerator < 0
        } else {
            return (self.numerator < 0) != (self.denominator < 0)
        }
    }

    /// Returns the specified term divided by an unsigned divisor while preserving its sign.
    ///
    /// - Parameter value: The term to reduce.
    /// - Parameter divisor: The unsigned divisor.
    /// - Returns: The reduced term.
    /// - Precondition: `divisor` must be greater than one and divide `value` exactly.
    private static func reducedTerm(
        _ value: Term,
        by divisor: Term.Magnitude
    ) -> Term {
        precondition(
            divisor > 1 && value.magnitude % divisor == 0,
            "The divisor must reduce the term exactly."
        )

        let reducedMagnitude: Term.Magnitude = value.magnitude / divisor

        guard let reducedTerm: Term = .init(exactly: reducedMagnitude) else {
            preconditionFailure("The reduced magnitude must be representable by the term type.")
        }

        return value < 0 ? 0 - reducedTerm : reducedTerm
    }

    /// Returns the reduced magnitudes of the specified terms.
    private static func reducedMagnitudes(
        numerator: Term,
        denominator: Term
    ) -> (numerator: Term.Magnitude, denominator: Term.Magnitude) {
        let divisor: Term.Magnitude = gcd(
            numerator,
            denominator
        )

        return (
            numerator: numerator.magnitude / divisor,
            denominator: denominator.magnitude / divisor
        )
    }

    /// Returns the parity of the exponent relating the specified reduced terms, or `nil` when the value terms are not a
    /// power of the base terms.
    private static func exponentIsOdd(
        valueNumerator: Term.Magnitude,
        valueDenominator: Term.Magnitude,
        baseNumerator: Term.Magnitude,
        baseDenominator: Term.Magnitude
    ) -> Bool? {
        var numerator: Term.Magnitude = valueNumerator
        var denominator: Term.Magnitude = valueDenominator
        var isExponentOdd: Bool = false

        while numerator != 1 || denominator != 1 {
            guard numerator % baseNumerator == 0,
                denominator % baseDenominator == 0
            else {
                return nil
            }

            numerator /= baseNumerator
            denominator /= baseDenominator
            isExponentOdd.toggle()
        }

        return isExponentOdd
    }

    /// Returns a canonical infinity with the specified sign.
    ///
    /// An unsigned term cannot represent negative infinity, so that case produces NaN.
    private static func infinity(withNegativeSign isNegative: Bool) -> Self {
        guard isNegative else {
            return .infinity
        }

        guard Term.isSigned else {
            return .nan
        }

        return .init(0 - 1, 0)
    }

    /// Returns zero with the specified sign when the term can represent it.
    private static func zero(withNegativeSign isNegative: Bool) -> Self {
        guard isNegative && Term.isSigned else {
            return .zero
        }

        return .init(0, 0 - 1)
    }
}

// MARK: - Addable

extension Fraction: Addable {
    /// Returns the sum of the specified values.
    ///
    /// Fractions with the same stored denominator retain that denominator. Other finite fractions use
    /// cross-multiplication and preserve the resulting terms without automatically canonicalizing them. Adding
    /// infinities with opposite signs produces NaN; otherwise, an infinite operand determines the result.
    ///
    /// Finite addition can trap when an intermediate or result cannot be represented by `Term`.
    ///
    /// For example:
    ///
    /// ```swift
    /// let lhs = Fraction<Int>(1, 2)
    /// let rhs = Fraction<Int>(1, 2)
    ///
    /// print(lhs + rhs)
    /// // Prints "2/2"
    /// ```
    ///
    /// - Parameter lhs: The first value to add.
    /// - Parameter rhs: The second value to add.
    /// - Returns: The sum, or NaN when the operation is indeterminate.
    public static func + (
        _ lhs: Self,
        _ rhs: Self
    ) -> Self {
        guard lhs.isNaN == false && rhs.isNaN == false else {
            return .nan
        }

        switch (lhs.isInfinite, rhs.isInfinite) {
        case (true, true) where lhs.hasNegativeSign != rhs.hasNegativeSign:
            return .nan
        case (true, _):
            return .infinity(withNegativeSign: lhs.hasNegativeSign)
        case (_, true):
            return .infinity(withNegativeSign: rhs.hasNegativeSign)
        case (false, false):
            break
        }

        let newNumerator: Term
        let newDenominator: Term

        if lhs.isLike(rhs) {
            newNumerator = lhs.numerator + rhs.numerator
            newDenominator = lhs.denominator
        } else {
            newNumerator = lhs.numerator * rhs.denominator + lhs.denominator * rhs.numerator
            newDenominator = lhs.denominator * rhs.denominator
        }

        return .init(newNumerator, newDenominator)
    }
}

// MARK: - AdditiveArithmetic

extension Fraction: AdditiveArithmetic {}

// MARK: - Canonicalizable

extension Fraction: Canonicalizable {
    /// A boolean value indicating whether this value can be converted to its canonicalized representation.
    ///
    /// This property is `true` when the fraction can be canonicalized safely, including when it is already
    /// canonicalized and the operation leaves it unchanged. Simplification is always safe, so canonicalization is safe
    /// when the resulting simplified fraction can be normalized without arithmetic overflow.
    public var isCanonicalizable: Bool {
        let simplified: Self = self.simplified()
        return simplified.isNormalizable
    }

    /// A boolean value indicating whether this value is in its canonicalized representation.
    ///
    /// A canonical fraction is both simplified and normalized. Its numerator and denominator have no common factor
    /// greater than one, and its denominator is nonnegative. Nonfinite fractions are already canonicalized.
    public var isCanonicalized: Bool {
        return self.isSimplified && self.isNormalized
    }

    /// Returns the canonicalized representation of this value.
    ///
    /// Canonicalization first removes common factors and then moves any negative sign to the numerator. Simplifying
    /// first can make normalization representable for values whose original terms cannot both be negated.
    ///
    /// - Precondition: `isCanonicalizable` is `true`.
    public func canonicalized() -> Self {
        let simplified: Self = self.simplified()

        precondition(
            simplified.isNormalizable,
            "The fraction must be canonicalizable."
        )

        return simplified.normalized()
    }
}

// MARK: - CanonicallyEquatable

extension Fraction: CanonicallyEquatable {}

// MARK: - Comparable

extension Fraction: Comparable {
    /// Returns a boolean value indicating whether the first value precedes the second in the fraction ordering.
    ///
    /// Values are ordered first by their canonical rational value. When two distinct stored representations are
    /// canonically equivalent, their numerators and then their denominators are used as tie-breakers. This preserves a
    /// total ordering among non-NaN representations that is consistent with representation-sensitive equality. A
    /// comparison involving NaN returns `false`.
    ///
    /// For example:
    ///
    /// ```swift
    /// let reduced = Fraction<Int>(1, 2)
    /// let unreduced = Fraction<Int>(2, 4)
    ///
    /// print(reduced < unreduced)
    /// // Prints "true"
    /// ```
    ///
    /// - Parameter lhs: The first value to compare.
    /// - Parameter rhs: The second value to compare.
    /// - Returns: `true` when the first value precedes the second, and `false` otherwise.
    public static func < (
        _ lhs: Self,
        _ rhs: Self
    ) -> Bool {
        switch RationalComparator.compare(lhs, rhs) {
        case .ascending:
            return true
        case .descending, nil:
            return false
        case .equivalent:
            if lhs.numerator != rhs.numerator {
                return lhs.numerator < rhs.numerator
            } else {
                return lhs.denominator < rhs.denominator
            }
        }
    }

    /// Returns a boolean value indicating whether the first value precedes or equals the second in the fraction
    /// ordering.
    ///
    /// This comparison returns `false` when either value is NaN. Canonically equivalent values compare as equal only
    /// when their stored representations are equal; otherwise, the stored-term tie-breakers used by `<` determine their
    /// order.
    ///
    /// - Parameter lhs: The first value to compare.
    /// - Parameter rhs: The second value to compare.
    /// - Returns: `true` when the first value precedes or equals the second, and `false` otherwise.
    public static func <= (
        _ lhs: Self,
        _ rhs: Self
    ) -> Bool {
        guard lhs.isNaN == false && rhs.isNaN == false else {
            return false
        }

        return lhs < rhs || lhs == rhs
    }

    /// Returns a boolean value indicating whether the first value follows or equals the second in the fraction
    /// ordering.
    ///
    /// This comparison returns `false` when either value is NaN. Canonically equivalent values compare as equal only
    /// when their stored representations are equal; otherwise, the stored-term tie-breakers used by `<` determine their
    /// order.
    ///
    /// - Parameter lhs: The first value to compare.
    /// - Parameter rhs: The second value to compare.
    /// - Returns: `true` when the first value follows or equals the second, and `false` otherwise.
    public static func >= (
        _ lhs: Self,
        _ rhs: Self
    ) -> Bool {
        guard lhs.isNaN == false && rhs.isNaN == false else {
            return false
        }

        return rhs < lhs || lhs == rhs
    }
}

// MARK: - CustomDebugStringConvertible

extension Fraction: CustomDebugStringConvertible {
    /// A textual representation of this value suitable for debugging.
    ///
    /// The representation includes the concrete term type and both stored terms, including for nonfinite values.
    public var debugDescription: String {
        let numerator: String = String(reflecting: self.numerator)
        let denominator: String = String(reflecting: self.denominator)

        return "Fraction<\(Term.self)>(\(numerator), \(denominator))"
    }
}

// MARK: - CustomStringConvertible

extension Fraction: CustomStringConvertible {
    /// A textual representation of this value.
    ///
    /// Finite values contain both stored terms separated by a slash, including whole and zero values. Nonfinite values
    /// use `"inf"`, `"-inf"`, or `"nan"`.
    public var description: String {
        if self.isNaN {
            return "nan"
        } else if self.isInfinite {
            return self.hasNegativeSign ? "-inf" : "inf"
        } else {
            return "\(self.numerator)/\(self.denominator)"
        }
    }
}

// MARK: - Decodable

extension Fraction: Decodable
where Term: Decodable {
    /// Creates a rational value by decoding keyed numerator and denominator terms.
    ///
    /// The `"num"` and `"den"` keys contain the stored terms. A decoded nonzero numerator with a zero denominator is
    /// canonicalized to `1/0` or `-1/0`.
    ///
    /// - Parameter decoder: The decoder to read data from.
    /// - Throws: Any error encountered while decoding the numerator or denominator.
    public init(from decoder: any Decoder) throws {
        let container: KeyedDecodingContainer<Self.CodingKeys> = try decoder.container(keyedBy: Self.CodingKeys.self)
        let numerator: Term = try container.decode(
            Term.self,
            forKey: .numerator
        )
        let denominator: Term = try container.decode(
            Term.self,
            forKey: .denominator
        )

        self.init(numerator, denominator)
    }
}

// MARK: - Divisible

extension Fraction: Divisible {
    /// The reciprocal of this value, or `nil` when this value is zero or NaN.
    ///
    /// A finite reciprocal exchanges the stored numerator and denominator. The reciprocal of positive or negative
    /// infinity is zero with the corresponding sign.
    public var reciprocal: Self? {
        guard self.isInvertible else {
            return nil
        }

        return .init(self.denominator, self.numerator)
    }

    /// A boolean value indicating whether this value has a reciprocal.
    ///
    /// Every value except zero and NaN has a reciprocal. In particular, infinity is invertible under the extended
    /// arithmetic semantics because its reciprocal is signed zero.
    public var isInvertible: Bool {
        return self.isZero == false
            && self.isNaN == false
    }

    /// Returns a boolean value indicating whether this value is exactly divisible by the specified value.
    ///
    /// Both values must be finite, and the divisor must be nonzero. Divisibility is determined by whether division
    /// produces an exactly zero rational remainder.
    ///
    /// This operation can trap when an intermediate remainder term cannot be represented by `Term`.
    ///
    /// - Parameter other: The value to test as a divisor.
    /// - Returns: `true` when the remainder is zero, and `false` otherwise.
    public func isDivisible(by other: Self) -> Bool {
        guard self.isFinite, other.isFinite, other.isZero == false else {
            return false
        }

        return (self % other).isZero
    }

    /// Returns the quotient of dividing the first specified value by the second.
    ///
    /// Finite division multiplies the stored terms by the reciprocal terms of the divisor, preserving an exact rational
    /// result without automatically canonicalizing it. Division by zero produces signed infinity except when the
    /// dividend is also zero. Zero divided by zero and infinity divided by infinity produce NaN, while a finite value
    /// divided by infinity produces signed zero.
    ///
    /// Finite division can trap when an intermediate or result cannot be represented by `Term`.
    ///
    /// For example:
    ///
    /// ```swift
    /// let dividend = Fraction<Int>(1, 2)
    /// let divisor = Fraction<Int>(1, 3)
    ///
    /// print(dividend / divisor)
    /// // Prints "3/2"
    /// ```
    ///
    /// - Parameter lhs: The dividend.
    /// - Parameter rhs: The divisor.
    /// - Returns: The quotient, or NaN for indeterminate forms such as zero divided by zero or infinity divided by
    ///            infinity.
    public static func / (
        _ lhs: Self,
        _ rhs: Self
    ) -> Self {
        guard lhs.isNaN == false && rhs.isNaN == false else {
            return .nan
        }

        if lhs.isInfinite && rhs.isInfinite {
            return .nan
        } else if lhs.isZero && rhs.isZero {
            return .nan
        } else if rhs.isZero || lhs.isInfinite {
            return .infinity(withNegativeSign: lhs.hasNegativeSign != rhs.hasNegativeSign)
        } else if rhs.isInfinite {
            return .zero(withNegativeSign: lhs.hasNegativeSign != rhs.hasNegativeSign)
        } else {
            return .init(lhs.numerator * rhs.denominator, lhs.denominator * rhs.numerator)
        }
    }

    /// Returns the remainder of dividing the first specified value by the second.
    ///
    /// Finite remainder uses the quotient truncated toward zero and preserves the resulting rational terms without
    /// automatically canonicalizing them. A finite dividend divided by infinity returns the dividend unchanged. An
    /// infinite dividend, a zero divisor, or either operand being NaN produces NaN.
    ///
    /// Finite remainder can trap when an intermediate or result cannot be represented by `Term`.
    ///
    /// For example:
    ///
    /// ```swift
    /// let dividend = Fraction<Int>(7, 2)
    /// let divisor = Fraction<Int>(3, 2)
    ///
    /// print(dividend % divisor)
    /// // Prints "1/2"
    /// ```
    ///
    /// - Parameter lhs: The dividend.
    /// - Parameter rhs: The divisor.
    /// - Returns: The remainder, or NaN when the dividend is infinite, the divisor is zero, or either operand is NaN.
    public static func % (
        _ lhs: Self,
        _ rhs: Self
    ) -> Self {
        guard lhs.isNaN == false,
            rhs.isNaN == false,
            lhs.isInfinite == false,
            rhs.isZero == false
        else {
            return .nan
        }

        guard rhs.isInfinite == false else {
            return lhs
        }

        let newNumerator: Term
        let newDenominator: Term

        if lhs.isLike(rhs) {
            newNumerator = lhs.numerator % rhs.numerator
            newDenominator = lhs.denominator
        } else {
            newNumerator = (lhs.numerator * rhs.denominator)
                % (lhs.denominator * rhs.numerator)
            newDenominator = lhs.denominator * rhs.denominator
        }

        return .init(newNumerator, newDenominator)
    }
}

// MARK: - Encodable

extension Fraction: Encodable
where Term: Encodable {
    /// Encodes this value as keyed numerator and denominator terms.
    ///
    /// The compact `"num"` and `"den"` keys are used. Infinities encode with their canonical numerator of `1` or `-1`
    /// and a denominator of `0`.
    ///
    /// - Parameter encoder: The encoder to write data to.
    /// - Throws: Any error encountered while encoding the numerator or denominator.
    public func encode(to encoder: any Encoder) throws {
        var container: KeyedEncodingContainer<Self.CodingKeys> = encoder.container(keyedBy: Self.CodingKeys.self)

        try container.encode(
            self.numerator,
            forKey: .numerator
        )
        try container.encode(
            self.denominator,
            forKey: .denominator
        )
    }
}

// MARK: - Equatable

extension Fraction: Equatable {
    /// Returns a boolean value indicating whether two values have the same stored representation.
    ///
    /// Ordinary equality is representation-sensitive. For example, `1/2` and `2/4` represent the same canonical value
    /// but are not equal because their stored terms differ. Use `isCanonicallyEquatable(to:)` to compare their
    /// canonical values instead. NaN is not equal to any value, including itself.
    ///
    /// - Parameter lhs: A value to compare.
    /// - Parameter rhs: Another value to compare.
    /// - Returns: `true` when both stored terms are equal and neither value is NaN; otherwise, `false`.
    public static func == (
        _ lhs: Self,
        _ rhs: Self
    ) -> Bool {
        guard lhs.isNaN == false && rhs.isNaN == false else {
            return false
        }

        return lhs.numerator == rhs.numerator
            && lhs.denominator == rhs.denominator
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension Fraction: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = Int

    /// Creates a whole rational value from an integer literal.
    ///
    /// - Parameter value: The integer literal used to create the value.
    /// - Precondition: `value` must be exactly representable by `Term`.
    public init(integerLiteral value: Self.IntegerLiteralType) {
        guard let term: Term = .init(exactly: value) else {
            preconditionFailure("Fraction integer literal must be representable by its term type.")
        }

        self.init(term)
    }
}

// MARK: - Hashable

extension Fraction: Hashable {
    /// Hashes the numerator and denominator of this value as stored.
    ///
    /// Canonically equivalent representations can produce different hashes when their stored terms differ, consistently
    /// with representation-sensitive equality.
    ///
    /// - Parameter hasher: The hasher to use when combining the components of this value.
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.numerator)
        hasher.combine(self.denominator)
    }
}

// MARK: - LosslessStringConvertible

extension Fraction: LosslessStringConvertible
where Term: LosslessStringConvertible {
    /// Creates a rational value from a whole number, slash-separated ratio, infinity, or NaN.
    ///
    /// Slash-separated finite values preserve both parsed terms. Special-value names are case-insensitive and produce
    /// canonical nonfinite representations. Negative zero, negative infinity, negative NaN, and negative finite terms
    /// require a signed `Term`; these descriptions fail when `Term` is unsigned. A negative NaN spelling produces the
    /// single `0/0` NaN representation because integer terms cannot preserve a NaN sign.
    ///
    /// - Parameter description: A string such as `"2"`, `"1/2"`, `"inf"`, `"-infinity"`, or `"nan"`.
    public init?(_ description: String) {
        switch description.lowercased() {
        case "-0":
            guard Term.isSigned else {
                return nil
            }

            self = .negativeZero
            return
        case "inf", "+inf", "infinity", "+infinity":
            self = .infinity
            return
        case "-inf", "-infinity":
            guard Term.isSigned else {
                return nil
            }

            self = .init(0 - 1, 0)
            return
        case "nan", "+nan":
            self = .nan
            return
        case "-nan":
            guard Term.isSigned else {
                return nil
            }

            self = .nan
            return
        default:
            break
        }

        let terms = description.split(
            separator: "/",
            maxSplits: 1,
            omittingEmptySubsequences: false
        )

        switch terms.count {
        case 1:
            guard let numerator: Term = .init(String(terms[0])) else {
                return nil
            }

            self.init(numerator)
        case 2:
            guard let numerator: Term = .init(String(terms[0])),
                let denominator: Term = .init(String(terms[1]))
            else {
                return nil
            }

            self.init(numerator, denominator)
        default:
            return nil
        }
    }
}

// MARK: - Multipliable

extension Fraction: Multipliable {
    /// Returns a boolean value indicating whether this value is an exact multiple of the specified value.
    ///
    /// Zero is considered a multiple of zero. Otherwise, both values must be finite, the specified value must be
    /// nonzero, and division must produce an exactly zero rational remainder.
    ///
    /// This operation can trap when an intermediate remainder term cannot be represented by `Term`.
    ///
    /// - Parameter other: The value to test as a factor.
    /// - Returns: `true` when this value is an exact multiple of the specified value, and `false` otherwise.
    public func isMultiple(of other: Self) -> Bool {
        if self.isZero && other.isZero {
            return true
        }

        guard self.isFinite,
            return false
        }

        return (self % other).isZero
    }

    /// Returns the product of the specified values.
    ///
    /// Finite multiplication multiplies the stored numerators and denominators without automatically canonicalizing the
    /// result. Multiplying zero by infinity produces NaN. Other products involving infinity use the combined signs of
    /// both operands.
    ///
    /// Finite multiplication can trap when an intermediate or result cannot be represented by `Term`.
    ///
    /// For example:
    ///
    /// ```swift
    /// let lhs = Fraction<Int>(2, 3)
    /// let rhs = Fraction<Int>(3, 4)
    ///
    /// print(lhs * rhs)
    /// // Prints "6/12"
    /// ```
    ///
    /// - Parameter lhs: The first value to multiply.
    /// - Parameter rhs: The second value to multiply.
    /// - Returns: The product, or NaN when the operation is indeterminate.
    public static func * (
        _ lhs: Self,
        _ rhs: Self
    ) -> Self {
        guard lhs.isNaN == false && rhs.isNaN == false else {
            return .nan
        }

        switch (
            lhs.isInfinite || rhs.isInfinite,
            lhs.isZero || rhs.isZero
        ) {
        case (true, true):
            return .nan
        case (true, false):
            return .infinity(withNegativeSign: lhs.hasNegativeSign != rhs.hasNegativeSign)
        case (false, _):
            break
        }

        return .init(lhs.numerator * rhs.numerator, lhs.denominator * rhs.denominator)
    }
}

// MARK: - Negateable

extension Fraction: Negateable
where Term: Negateable {
    /// Returns the additive inverse of the specified value.
    ///
    /// Negation reverses only the stored numerator and leaves the denominator unchanged. A zero numerator therefore
    /// retains its stored representation, including the sign carried by its denominator.
    ///
    /// For example:
    ///
    /// ```swift
    /// let value = Fraction<Int>(1, 2)
    ///
    /// print(-value)
    /// // Prints "-1/2"
    /// ```
    ///
    /// - Parameter operand: The value to negate.
    /// - Returns: The negated value.
    /// - Precondition: The negation of `operand.numerator` must be representable by `Term`.
    public static prefix func - (_ operand: Self) -> Self {
        return .init(-operand.numerator, operand.denominator)
    }
}

// MARK: - Numeric

extension Fraction: Numeric {
    /// A fraction whose terms use the unsigned magnitude of `Term`.
    public typealias Magnitude = Fraction<Term.Magnitude>

    /// Creates a whole fraction from the specified binary integer when it is exactly representable by `Term`.
    ///
    /// A successful conversion stores the converted source as the numerator and one as the denominator.
    ///
    /// - Parameter source: The binary integer to convert.
    public init?<Source>(exactly source: Source)
    where Source: BinaryInteger {
        guard let value: Term = .init(exactly: source) else {
            return nil
        }

        self.init(value)
    }

    /// The magnitude of this fraction.
    ///
    /// The magnitude contains the unsigned magnitudes of the stored numerator and denominator. It therefore removes any
    /// sign carried by either term without requiring that magnitude to fit back into `Term`.
    public var magnitude: Self.Magnitude {
        return .init(self.numerator.magnitude, self.denominator.magnitude)
    }
}

// MARK: - Normalizable

extension Fraction: Normalizable {
    /// A boolean value indicating whether this value can be converted to its normalized representation.
    ///
    /// This property is `true` when the fraction can be normalized safely, including when it is already normalized and
    /// the operation leaves it unchanged. When the denominator is negative, normalization is safe when the negations of
    /// both terms can be represented by `Term` without arithmetic overflow.
    package var isNormalizable: Bool {
        guard self.denominator < 0 else {
            return true
        }

        let isNumeratorNegatable: Bool = self.numerator >= 0
            || Term(exactly: self.numerator.magnitude) != nil

        let isDenominatorNegatable: Bool = Term(exactly: self.denominator.magnitude) != nil

        return isNumeratorNegatable && isDenominatorNegatable
    }

    /// A boolean value indicating whether this value is in its normalized representation.
    ///
    /// A normalized finite value has a positive denominator so that any negative sign belongs in the numerator.
    /// Nonfinite values have a zero denominator and are already normalized. Normalization does not imply that the terms
    /// have been simplified.
    package var isNormalized: Bool {
        return self.denominator >= 0
    }

    /// Returns the normalized representation of this value.
    ///
    /// If a finite denominator is negative, this method reverses the signs of both terms. For example, `1/-2` becomes
    /// `-1/2`, and `-1/-2` becomes `1/2`. Nonfinite values are returned unchanged. This method does not simplify common
    /// factors.
    ///
    /// - Precondition: `isNormalizable` is `true`.
    package func normalized() -> Self {
        guard self.denominator < 0 else {
            return self
        }

        precondition(
            self.isNormalizable,
            "The fraction must be normalizable."
        )

        return .init(0 - self.numerator, 0 - self.denominator)
    }
}

// MARK: - Raisable

extension Fraction: Raisable {
    /// The integer type used to represent an exponent.
    public typealias Exponent = Int

    /// Returns a boolean value indicating whether this value is a power of the specified value.
    ///
    /// A value is a power of a base when raising the base to a positive, zero, or negative integer exponent produces
    /// that value. The comparison uses reduced numerator and denominator magnitudes without converting either value to
    /// floating point. Positive exponents compare against the base, while negative exponents compare against its
    /// reciprocal.
    ///
    /// This method treats one as a power of every base because an exponent of zero produces one, including when the
    /// base is NaN. NaN itself is never a power, while zero and infinity follow floating-point rules.
    ///
    /// For example:
    ///
    /// ```swift
    /// let value = Fraction<Int>(1, 4)
    /// let base = Fraction<Int>(2)
    ///
    /// print(value.isPower(of: base))
    /// // Prints "true"
    /// ```
    ///
    /// - Parameter other: The value to test.
    /// - Returns: `true` if this value is a power of the specified value, and `false` otherwise.
    public func isPower(of other: Self) -> Bool {
        guard self.isNaN == false else {
            return false
        }

        // An exponent of zero makes one a power of every base, including NaN.
        guard self.isOne == false else {
            return true
        }

        guard other.isNaN == false else {
            return false
        }

        // Handle zero and infinity without reducing their terms.
        if other.isZero || other.isInfinite {
            guard self.isZero || self.isInfinite else {
                return false
            }

            return self.isZero
                || other.hasNegativeSign
                || self.hasNegativeSign == false
        }

        guard self.isFinite,
            self.isZero == false
        else {
            return false
        }

        let valueTerms = Self.reducedMagnitudes(
            numerator: self.numerator,
            denominator: self.denominator
        )
        let baseTerms = Self.reducedMagnitudes(
            numerator: other.numerator,
            denominator: other.denominator
        )

        // Only one and negative one can be powers of a base with magnitude one.
        guard baseTerms.numerator != 1 || baseTerms.denominator != 1 else {
            return other.hasNegativeSign
                && self.hasNegativeSign
                && valueTerms.numerator == 1
                && valueTerms.denominator == 1
        }

        let isExponentOdd: Bool?

        // Search positive powers first, followed by powers of the reciprocal.
        if let positiveExponentIsOdd: Bool = Self.exponentIsOdd(
            valueNumerator: valueTerms.numerator,
            valueDenominator: valueTerms.denominator,
            baseNumerator: baseTerms.numerator,
            baseDenominator: baseTerms.denominator
        ) {
            isExponentOdd = positiveExponentIsOdd
        } else {
            isExponentOdd = Self.exponentIsOdd(
                valueNumerator: valueTerms.numerator,
                valueDenominator: valueTerms.denominator,
                baseNumerator: baseTerms.denominator,
                baseDenominator: baseTerms.numerator
            )
        }

        guard let isExponentOdd else {
            return false
        }

        let isExpectedNegative: Bool = other.hasNegativeSign
            && isExponentOdd

        return self.hasNegativeSign == isExpectedNegative
    }

    /// Returns the power of raising the first specified value to the second.
    ///
    /// A negative exponent raises the reciprocal of the base to the corresponding positive magnitude. An exponent of
    /// zero returns one, including when the base is NaN. Raising zero to a negative exponent produces signed infinity.
    /// Other NaN and infinity results follow the extended arithmetic rules of `Fraction`.
    ///
    /// Exponentiation preserves the terms produced by rational multiplication rather than automatically canonicalizing
    /// the result. Finite exponentiation can trap when an intermediate or result cannot be represented by `Term`.
    ///
    /// For example:
    ///
    /// ```swift
    /// let value = Fraction<Int>(2, 3)
    ///
    /// print(value ** -2)
    /// // Prints "9/4"
    /// ```
    ///
    /// - Parameter lhs: The base.
    /// - Parameter rhs: The exponent.
    /// - Returns: The power.
    public static func ** (
        _ lhs: Self,
        _ rhs: Self.Exponent
    ) -> Self {
        // Zero exponents return one before handling NaN.
        if rhs == 0 {
            return 1
        }

        guard lhs.isNaN == false else {
            return .nan
        }

        // A negative exponent of signed zero produces infinity with the corresponding parity sign.
        if lhs.isZero && rhs < 0 {
            return .infinity(withNegativeSign: lhs.hasNegativeSign && rhs.isMultiple(of: 2) == false)
        }

        // Zero and NaN were handled above, so every remaining negative-exponent base has a reciprocal.
        var base: Self = rhs < 0 ? lhs.reciprocal! : lhs
        // The unsigned magnitude represents every Int exponent, including Int.min.
        var exponent: UInt = rhs.magnitude
        var result: Self = 1

        // Exponentiation by squaring avoids linear work for large exponent magnitudes.
        while exponent > 0 {
            if exponent.isMultiple(of: 2) == false {
                result *= base
            }

            exponent /= 2

            if exponent > 0 {
                base *= base
            }
        }

        return result
    }
}

// MARK: - Rational

extension Fraction: Rational {}

// MARK: - Sendable

extension Fraction: Sendable
where Term: Sendable {}

// MARK: - SignedNumeric

extension Fraction: SignedNumeric
where Term: SignedInteger {}

// MARK: - Simplifiable

extension Fraction: Simplifiable {
    /// A boolean value indicating whether this value can be converted to its simplified representation.
    ///
    /// This property is always `true` because simplification cannot overflow and leaves fractions that are already
    /// simplified unchanged.
    package var isSimplifiable: Bool {
        return true
    }

    /// A boolean value indicating whether this value is in its simplified representation.
    ///
    /// A finite fraction is simplified when its terms have no common factor greater than one. Nonfinite fractions are
    /// already simplified.
    package var isSimplified: Bool {
        guard self.isNaN == false && self.isInfinite == false else {
            return true
        }

        let divisor: Term.Magnitude = gcd(
            self.numerator,
            self.denominator
        )

        return divisor <= 1
    }

    /// Returns the simplified representation of this value.
    ///
    /// Simplification divides both terms by their greatest common divisor without changing sign placement. A fraction
    /// that is already simplified is returned unchanged.
    package func simplified() -> Self {
        guard self.isNaN == false && self.isInfinite == false else {
            return self
        }

        let divisor: Term.Magnitude = gcd(
            self.numerator,
            self.denominator
        )

        guard divisor > 1 else {
            return self
        }

        return .init(
            Self.reducedTerm(
                self.numerator,
                by: divisor
            ),
            Self.reducedTerm(
                self.denominator,
                by: divisor
            )
        )
    }
}

// MARK: - Subtractable

extension Fraction: Subtractable {
    /// Returns the difference between the specified values.
    ///
    /// Fractions with the same stored denominator retain that denominator. Other finite fractions use
    /// cross-multiplication and preserve the resulting terms without automatically canonicalizing them. Subtracting
    /// infinities with the same sign produces NaN; otherwise, an infinite operand determines the result. When `Term`
    /// is unsigned, subtracting positive infinity from a finite value also produces NaN because negative infinity
    /// cannot be represented.
    ///
    /// Finite subtraction can trap when an intermediate or result cannot be represented by `Term`.
    ///
    /// For example:
    ///
    /// ```swift
    /// let lhs = Fraction<Int>(3, 4)
    /// let rhs = Fraction<Int>(1, 4)
    ///
    /// print(lhs - rhs)
    /// // Prints "2/4"
    /// ```
    ///
    /// - Parameter lhs: The value to subtract from.
    /// - Parameter rhs: The value to subtract.
    /// - Returns: The difference, or NaN when the operation is indeterminate or requires an unrepresentable negative
    ///            infinity.
    public static func - (
        _ lhs: Self,
        _ rhs: Self
    ) -> Self {
        guard lhs.isNaN == false && rhs.isNaN == false else {
            return .nan
        }

        switch (lhs.isInfinite, rhs.isInfinite) {
        case (true, true) where lhs.hasNegativeSign == rhs.hasNegativeSign:
            return .nan
        case (true, true):
            return .infinity(withNegativeSign: lhs.hasNegativeSign)
        case (true, false):
            return .infinity(withNegativeSign: lhs.hasNegativeSign)
        case (false, true):
            return .infinity(withNegativeSign: rhs.hasNegativeSign == false)
        case (false, false):
            break
        }

        let newNumerator: Term
        let newDenominator: Term

        if lhs.isLike(rhs) {
            newNumerator = lhs.numerator - rhs.numerator
            newDenominator = lhs.denominator
        } else {
            newNumerator = lhs.numerator * rhs.denominator - lhs.denominator * rhs.numerator
            newDenominator = lhs.denominator * rhs.denominator
        }

        return .init(newNumerator, newDenominator)
    }
}
