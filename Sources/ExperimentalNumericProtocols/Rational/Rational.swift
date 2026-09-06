// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import CoreNumericProtocols

/// A type that represents a finite or nonfinite rational value as a ratio of two binary integer terms.
///
/// A rational value has a numerator, which appears above the fraction bar, and a denominator, which appears below it. A
/// zero denominator represents infinity when the numerator is nonzero and NaN when the numerator is zero. Conforming
/// types may preserve distinct representations of the same canonical value. For example, `1/1` and `2/2` may be unequal
/// stored values while remaining canonically equal rational values. A conforming type determines whether it preserves
/// or canonicalizes equivalent nonfinite representations.
///
/// Conforming types support Swift's standard numeric operations, ordering, hashing, integer literals, and textual
/// descriptions. They also support the four basic arithmetic operations, canonicalization, and canonical equality
/// operations.
public protocol Rational:
    Canonicalizable,
    CanonicallyEquatable,
    Comparable,
    CustomStringConvertible,
    Hashable,
    Numeric,
    Operatable,
    RepresentableByInfinity,
    RepresentableByNaN,
    RepresentableByZero {
    /// The integer type used for the numerator and denominator.
    ///
    /// A signed term type permits negative rational representations, including negative zero and negative infinity.
    /// An unsigned term type can represent only nonnegative terms, so conforming types may be unable to express results
    /// that require a negative representation.
    associatedtype Term: BinaryInteger

    /// Creates a rational representation with the specified numerator and denominator.
    ///
    /// A zero denominator represents infinity when the numerator is nonzero and NaN when the numerator is zero. A
    /// conforming type determines whether it preserves the supplied terms or converts them to another equivalent
    /// representation.
    ///
    /// - Parameters:
    ///   - numerator: The numerator.
    ///   - denominator: The denominator. Zero creates a nonfinite value.
    init(
        _ numerator: Self.Term,
        _ denominator: Self.Term
    )

    /// The stored term above the fraction bar.
    var numerator: Self.Term { get }

    /// The stored term below the fraction bar.
    var denominator: Self.Term { get }
}

extension Rational {
    /// Creates a whole rational number with the specified value.
    ///
    /// - Parameter value: The whole value.
    public init(_ value: Self.Term) {
        self.init(value, 1)
    }

    /// A boolean value indicating whether this value represents one.
    ///
    /// Any rational representation with equal, nonzero numerator and denominator terms represents one. This property
    /// does not require the value to be simplified. For example, `1/1`, `3/3`, and `-3/-3` represent one, while `0/0`
    /// is NaN and does not.
    public var isOne: Bool {
        return self.numerator != 0
            && self.numerator == self.denominator
    }

    /// A boolean value indicating whether this value is a whole fraction.
    ///
    /// A whole fraction is finite, nonnegative, and has an integer quotient. This property is independent of the stored
    /// representation and does not require the value to be simplified. For example, `4/2`, `8/4`, `0/3`, and `-4/-2`
    /// are whole fractions, while `3/2` and `-4/2` are not.
    public var isWhole: Bool {
        guard self.isFinite else {
            return false
        }

        let isNumeratorZero: Bool = self.numerator == 0
        let termsHaveMatchingSigns: Bool = (self.numerator < 0) == (self.denominator < 0)
        let isNonnegative: Bool = isNumeratorZero || termsHaveMatchingSigns

        let isDenominatorMagnitudeOne: Bool = self.denominator.magnitude == 1
        let isEvenlyDivisible: Bool = self.numerator.magnitude % self.denominator.magnitude == 0
        let isInteger: Bool = isDenominatorMagnitudeOne || isEvenlyDivisible

        return isNonnegative && isInteger
    }

    /// A boolean value indicating whether this value is a proper fraction.
    ///
    /// A nonzero rational value is proper when its magnitude is strictly less than one. Equivalently, the magnitude of
    /// its numerator is less than the magnitude of its denominator. For example, `1/2` and `-1/2` are proper, while
    /// zero is neither proper nor improper.
    public var isProper: Bool {
        return self.numerator != 0
            && self.numerator.magnitude < self.denominator.magnitude
    }

    /// A boolean value indicating whether this value is an improper fraction.
    ///
    /// A rational value is improper when its magnitude is greater than or equal to one. Equivalently, the magnitude of
    /// its numerator is greater than or equal to the magnitude of its denominator. For example, `3/2`, `-3/2`, and
    /// `2/2` are improper.
    public var isImproper: Bool {
        return self.isFinite
            && self.numerator.magnitude >= self.denominator.magnitude
    }

    /// A boolean value indicating whether this value is a unit fraction.
    ///
    /// A stored representation is a unit fraction when its numerator is one and its denominator is positive. For
    /// example, `1/2` is a unit fraction. An equivalent but unnormalized representation such as `-1/-2` becomes a unit
    /// fraction after normalization.
    public var isUnit: Bool {
        return self.numerator == 1
            && self.denominator > 0
    }

    /// A binary floating-point approximation of this value.
    ///
    /// The quotient is the result of dividing the numerator by the denominator and storing that result as a `Double`.
    /// This conversion may round finite values that cannot be represented exactly. Infinite values produce a `Double`
    /// infinity, and NaN produces `Double.nan`. This property does not alter the stored numerator or denominator.
    public var quotient: Double {
        return .init(self.numerator) / .init(self.denominator)
    }

    /// Returns a boolean value indicating whether this value has the same stored denominator as the specified value.
    ///
    /// Fractions with the same denominator are called like fractions. This comparison is representation-sensitive:
    /// `1/4` and `3/4` are like, while the canonically equal representations `1/2` and `2/4` are not.
    ///
    /// - Parameter rhs: The value to compare.
    /// - Returns: `true` if both stored denominators are equal, and `false` otherwise.
    public func isLike(_ rhs: Self) -> Bool {
        return self.denominator == rhs.denominator
    }
}

// MARK: - CanonicallyEquatable

extension Rational {
    /// Returns a boolean value indicating whether this value is canonically equal to the specified value.
    ///
    /// Canonical equality compares the rational values represented by both operands without requiring their stored
    /// terms to match. For example, `1/2` and `2/4` are canonically equal even when ordinary equality considers their
    /// stored terms unequal. NaN is never canonically equal to any value, including itself.
    ///
    /// - Parameter rhs: The value to compare.
    /// - Returns: `true` if both values have the same canonical representation, and `false` otherwise.
    public func isCanonicallyEquatable(to rhs: Self) -> Bool {
        return RationalComparator.compare(self, rhs) == .equivalent
    }
}

// MARK: - RepresentableByInfinity

extension Rational {
    /// A boolean value indicating whether this value is finite.
    public var isFinite: Bool {
        return self.denominator != 0
    }

    /// A boolean value indicating whether this value is infinite.
    ///
    /// A rational representation is infinite when its numerator is nonzero and its denominator is zero.
    public var isInfinite: Bool {
        return self.numerator != 0
            && self.denominator == 0
    }

    /// Positive infinity, represented by `1/0`.
    public static var infinity: Self {
        return .init(1, 0)
    }
}

// MARK: - RepresentableByNaN

extension Rational {
    /// A boolean value indicating whether this value is not a number.
    ///
    /// The representation `0/0` is NaN because division of zero by zero is indeterminate.
    public var isNaN: Bool {
        return self.numerator == 0
            && self.denominator == 0
    }

    /// A not-a-number value, represented by `0/0`.
    public static var nan: Self {
        return .init(0, 0)
    }
}

// MARK: - RepresentableByZero

extension Rational {
    /// A boolean value indicating whether this value represents zero.
    ///
    /// Any rational representation with a zero numerator and nonzero denominator represents zero. For example, both
    /// `0/1` and `0/2` are zero even though they are not ordinarily equal stored representations. The expression `0/0`
    /// is NaN and does not represent zero.
    public var isZero: Bool {
        return self.numerator == 0
            && self.denominator != 0
    }

    /// The value representing zero, represented by `0/1`.
    public static var zero: Self {
        return .init(0, 1)
    }

    /// The value representing negative zero, represented by `0/-1` when the term type is signed.
    ///
    /// The negative sign is stored in the denominator because an integer numerator cannot preserve a distinct negative
    /// zero. Canonicalizing this value produces `0/1`. An unsigned term type cannot preserve the sign and therefore
    /// uses the ordinary zero representation.
    public static var negativeZero: Self {
        guard Self.Term.isSigned else {
            return .zero
        }

        return .init(0, 0 - 1)
    }
}
