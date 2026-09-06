// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

/// A namespace for comparing rational values without cross-multiplication.
package enum RationalComparator {
    /// The ordering of two rational values.
    package enum Ordering {
        case ascending
        case equivalent
        case descending

        /// The ordering produced by exchanging the two operands.
        fileprivate var reversed: Self {
            switch self {
            case .ascending:
                return .descending
            case .equivalent:
                return .equivalent
            case .descending:
                return .ascending
            }
        }
    }

    /// Returns the ordering of the specified rational values.
    ///
    /// This comparison evaluates continued-fraction terms using unsigned magnitudes rather than cross-multiplying the
    /// stored terms. NaN is unordered and produces `nil`.
    ///
    /// - Parameters:
    ///   - lhs: The first rational value.
    ///   - rhs: The second rational value.
    /// - Returns: The ordering of the values, or `nil` when either value is NaN.
    package static func compare<Value>(
        _ lhs: Value,
        _ rhs: Value
    ) -> Ordering?
    where Value: Rational {
        guard lhs.isNaN == false && rhs.isNaN == false else {
            return nil
        }

        switch (lhs.isInfinite, rhs.isInfinite) {
        case (true, true):
            if lhs.numerator < 0 {
                return rhs.numerator < 0 ? .equivalent : .ascending
            } else {
                return rhs.numerator < 0 ? .descending : .equivalent
            }
        case (true, false):
            return lhs.numerator < 0 ? .ascending : .descending
        case (false, true):
            return rhs.numerator < 0 ? .descending : .ascending
        case (false, false):
            break
        }

        // Treat every finite zero as nonnegative; otherwise, exactly one negative term makes the value negative.
        let lhsIsNonzero: Bool = lhs.numerator != 0
        let lhsTermsHaveDifferentSigns: Bool = (lhs.numerator < 0) != (lhs.denominator < 0)
        let lhsIsNegative: Bool = lhsIsNonzero && lhsTermsHaveDifferentSigns

        let rhsIsNonzero: Bool = rhs.numerator != 0
        let rhsTermsHaveDifferentSigns: Bool = (rhs.numerator < 0) != (rhs.denominator < 0)
        let rhsIsNegative: Bool = rhsIsNonzero && rhsTermsHaveDifferentSigns

        if lhsIsNegative != rhsIsNegative {
            return lhsIsNegative ? .ascending : .descending
        }

        let ordering: Ordering = self.compareMagnitudes(
            (numerator: lhs.numerator.magnitude, denominator: lhs.denominator.magnitude),
            (numerator: rhs.numerator.magnitude, denominator: rhs.denominator.magnitude)
        )

        return lhsIsNegative ? ordering.reversed : ordering
    }

    /// Returns the ordering of two nonnegative rational magnitudes.
    ///
    /// - Parameters:
    ///   - lhs: The first numerator and denominator magnitudes.
    ///   - rhs: The second numerator and denominator magnitudes.
    /// - Returns: The ordering of the two rational magnitudes.
    /// - Precondition: Both denominators must be greater than zero.
    private static func compareMagnitudes<Magnitude>(
        _ lhs: (numerator: Magnitude, denominator: Magnitude),
        _ rhs: (numerator: Magnitude, denominator: Magnitude)
    ) -> Ordering
    where Magnitude: BinaryInteger {
        precondition(
            lhs.denominator > 0 && rhs.denominator > 0,
            "Rational comparison denominators must be positive."
        )

        var lhsDividend: Magnitude = lhs.numerator
        var lhsDivisor: Magnitude = lhs.denominator
        var rhsDividend: Magnitude = rhs.numerator
        var rhsDivisor: Magnitude = rhs.denominator
        var isReversed: Bool = false

        while true {
            // Each quotient is the next coefficient in the value's simple continued-fraction expansion.
            let lhsQuotient: Magnitude = lhsDividend / lhsDivisor
            let lhsRemainder: Magnitude = lhsDividend % lhsDivisor
            let rhsQuotient: Magnitude = rhsDividend / rhsDivisor
            let rhsRemainder: Magnitude = rhsDividend % rhsDivisor

            if lhsQuotient != rhsQuotient {
                let ordering: Ordering = lhsQuotient < rhsQuotient ? .ascending : .descending

                return isReversed ? ordering.reversed : ordering
            }

            // A zero remainder terminates an expansion; otherwise, compare the reciprocal fractional parts.
            switch (lhsRemainder == 0, rhsRemainder == 0) {
            case (true, true):
                return .equivalent
            case (true, false):
                return isReversed ? .descending : .ascending
            case (false, true):
                return isReversed ? .ascending : .descending
            case (false, false):
                lhsDividend = lhsDivisor
                lhsDivisor = lhsRemainder
                rhsDividend = rhsDivisor
                rhsDivisor = rhsRemainder

                // Taking reciprocals reverses the ordering at every continued-fraction step.
                isReversed.toggle()
            }
        }
    }
}
