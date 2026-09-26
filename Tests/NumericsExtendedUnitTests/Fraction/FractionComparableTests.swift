// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Fraction Comparable Tests")
internal struct FractionComparableTests {
    private static let comparisonArguments: [(Fraction<Int>, Fraction<Int>, Bool, Bool, Bool, Bool)] = [
        (Fraction<Int>(1, 2), Fraction<Int>(1, 2), false, true, false, true),
        (Fraction<Int>(-1, 2), Fraction<Int>(-1, 2), false, true, false, true),
        (Fraction<Int>(1, 2), Fraction<Int>(2, 4), true, true, false, false),
        (Fraction<Int>(2, 4), Fraction<Int>(1, 2), false, false, true, true),
        (Fraction<Int>(2, 2), Fraction<Int>(3, 2), true, true, false, false),
        (Fraction<Int>(3, 2), Fraction<Int>(2, 2), false, false, true, true),
        (Fraction<Int>(-2, 2), Fraction<Int>(3, 2), true, true, false, false),
        (Fraction<Int>(-3, 2), Fraction<Int>(-2, 2), true, true, false, false)
    ]

    private static let rangeArguments: [(Fraction<Int>, Fraction<Int>, Fraction<Int>)] = [
        (Fraction<Int>(1, 2), Fraction<Int>(2, 2), Fraction<Int>(4, 2)),
        (Fraction<Int>(2, 2), Fraction<Int>(2, 2), Fraction<Int>(4, 2)),
        (Fraction<Int>(3, 2), Fraction<Int>(2, 2), Fraction<Int>(4, 2)),
        (Fraction<Int>(4, 2), Fraction<Int>(2, 2), Fraction<Int>(4, 2)),
        (Fraction<Int>(5, 2), Fraction<Int>(2, 2), Fraction<Int>(4, 2)),
        (Fraction<Int>(-5, 2), Fraction<Int>(-4, 2), Fraction<Int>(-2, 2)),
        (Fraction<Int>(-4, 2), Fraction<Int>(-4, 2), Fraction<Int>(-2, 2)),
        (Fraction<Int>(-3, 2), Fraction<Int>(-4, 2), Fraction<Int>(-2, 2)),
        (Fraction<Int>(-2, 2), Fraction<Int>(-4, 2), Fraction<Int>(-2, 2)),
        (Fraction<Int>(-1, 2), Fraction<Int>(-4, 2), Fraction<Int>(-2, 2))
    ]

    @Test(
        "Is less than",
        arguments: Self.comparisonArguments
    )
    internal func isLessThan(
        lhs: Fraction<Int>,
        rhs: Fraction<Int>,
        isLess: Bool,
        isLessThanOrEqual _: Bool,
        isGreater _: Bool,
        isGreaterThanOrEqual _: Bool
    ) {
        #expect((lhs < rhs) == isLess)
        #expect(lhs.isLess(than: rhs) == isLess)
    }

    @Test(
        "Is less than or equal",
        arguments: Self.comparisonArguments
    )
    internal func isLessThanOrEqualTo(
        lhs: Fraction<Int>,
        rhs: Fraction<Int>,
        isLess _: Bool,
        isLessThanOrEqual: Bool,
        isGreater _: Bool,
        isGreaterThanOrEqual _: Bool
    ) {
        #expect((lhs <= rhs) == isLessThanOrEqual)
        #expect(lhs.isLessThanOrEqual(to: rhs) == isLessThanOrEqual)
    }

    @Test(
        "Is greater than",
        arguments: Self.comparisonArguments
    )
    internal func isGreaterThan(
        lhs: Fraction<Int>,
        rhs: Fraction<Int>,
        isLess _: Bool,
        isLessThanOrEqual _: Bool,
        isGreater: Bool,
        isGreaterThanOrEqual _: Bool
    ) {
        #expect((lhs > rhs) == isGreater)
        #expect(lhs.isGreater(than: rhs) == isGreater)
    }

    @Test(
        "Is greater than or equal",
        arguments: Self.comparisonArguments
    )
    internal func isGreaterThanOrEqualTo(
        lhs: Fraction<Int>,
        rhs: Fraction<Int>,
        isLess _: Bool,
        isLessThanOrEqual _: Bool,
        isGreater _: Bool,
        isGreaterThanOrEqual: Bool
    ) {
        #expect((lhs >= rhs) == isGreaterThanOrEqual)
        #expect(lhs.isGreaterThanOrEqual(to: rhs) == isGreaterThanOrEqual)
    }

    @Test(
        "Is within closed range",
        arguments: Self.rangeArguments
    )
    internal func isWithinClosedRange(
        value: Fraction<Int>,
        lowerBound: Fraction<Int>,
        upperBound: Fraction<Int>
    ) {
        let range: ClosedRange<Fraction<Int>> = lowerBound ... upperBound

        #expect(value.isWithin(range) == range.contains(value))
    }

    @Test(
        "Is within bounds",
        arguments: Self.rangeArguments
    )
    internal func isWithinBounds(
        value: Fraction<Int>,
        lowerBound: Fraction<Int>,
        upperBound: Fraction<Int>
    ) {
        let valueIsWithinBounds: Bool = value.isWithin(lowerBound, upperBound) == true

        #expect(valueIsWithinBounds == (value >= lowerBound && value <= upperBound))
    }

    @Test(
        "Is between bounds",
        arguments: Self.rangeArguments
    )
    internal func isBetweenBounds(
        value: Fraction<Int>,
        lowerBound: Fraction<Int>,
        upperBound: Fraction<Int>
    ) {
        let valueIsBetweenBounds: Bool = value.isBetween(lowerBound, upperBound) == true

        #expect(valueIsBetweenBounds == (value > lowerBound && value < upperBound))
    }
}

// MARK: - IntMin

extension FractionComparableTests {
    @Test("Comparison handles an Int minimum denominator")
    internal func comparisonHandlesIntMinimumDenominator() {
        let value: Fraction<Int> = .init(1, Int.min)

        #expect(value < .zero)
    }

    @Test("Comparison handles an Int minimum numerator")
    internal func comparisonHandlesIntMinimumNumerator() {
        let value: Fraction<Int> = .init(Int.min, -1)
        let maximum: Fraction<Int> = .init(Int.max, 1)

        #expect(value > maximum)
    }
}

// MARK: - NaN

extension FractionComparableTests {
    @Test(
        "NaN comparison follows rational rules",
        arguments: [
            (Fraction<Int>.nan, Fraction<Int>(1, 1)),
            (Fraction<Int>(1, 1), Fraction<Int>.nan),
            (Fraction<Int>.nan, Fraction<Int>.nan)
        ]
    )
    internal func nanComparisonFollowsRationalRules(
        lhs: Fraction<Int>,
        rhs: Fraction<Int>
    ) {
        #expect((lhs < rhs) == false)
        #expect((lhs > rhs) == false)
        #expect((lhs <= rhs) == false)
        #expect((lhs >= rhs) == false)
        #expect(lhs.isLess(than: rhs) == false)
        #expect(lhs.isLessThanOrEqual(to: rhs) == false)
        #expect(lhs.isGreater(than: rhs) == false)
        #expect(lhs.isGreaterThanOrEqual(to: rhs) == false)
    }
}

// MARK: - Negative Infinity

extension FractionComparableTests {
    @Test(
        "Negative infinity comparison follows rational rules",
        arguments: [
            (Fraction<Int>.negativeInfinity, Fraction<Int>.negativeInfinity, false, true, false, true),
            (Fraction<Int>.negativeInfinity, Fraction<Int>(-1, 1), true, true, false, false),
            (Fraction<Int>.negativeInfinity, Fraction<Int>.infinity, true, true, false, false)
        ]
    )
    internal func negativeInfinityComparisonFollowsRationalRules(
        lhs: Fraction<Int>,
        rhs: Fraction<Int>,
        isLess: Bool,
        isLessThanOrEqual: Bool,
        isGreater: Bool,
        isGreaterThanOrEqual: Bool
    ) {
        #expect((lhs < rhs) == isLess)
        #expect((lhs <= rhs) == isLessThanOrEqual)
        #expect((lhs > rhs) == isGreater)
        #expect((lhs >= rhs) == isGreaterThanOrEqual)
        #expect(lhs.isLess(than: rhs) == isLess)
        #expect(lhs.isLessThanOrEqual(to: rhs) == isLessThanOrEqual)
        #expect(lhs.isGreater(than: rhs) == isGreater)
        #expect(lhs.isGreaterThanOrEqual(to: rhs) == isGreaterThanOrEqual)
    }
}

// MARK: - Negative Zero

extension FractionComparableTests {
    @Test(
        "Negative zero comparison follows stored representation rules",
        arguments: [
            (Fraction<Int>.negativeZero, Fraction<Int>.negativeZero, false, true, false, true),
            (Fraction<Int>.negativeZero, Fraction<Int>.zero, true, true, false, false),
            (Fraction<Int>.negativeZero, Fraction<Int>(1, 1), true, true, false, false),
            (Fraction<Int>.negativeZero, Fraction<Int>(-1, 1), false, false, true, true)
        ]
    )
    internal func negativeZeroComparisonFollowsStoredRepresentationRules(
        lhs: Fraction<Int>,
        rhs: Fraction<Int>,
        isLess: Bool,
        isLessThanOrEqual: Bool,
        isGreater: Bool,
        isGreaterThanOrEqual: Bool
    ) {
        #expect((lhs < rhs) == isLess)
        #expect((lhs <= rhs) == isLessThanOrEqual)
        #expect((lhs > rhs) == isGreater)
        #expect((lhs >= rhs) == isGreaterThanOrEqual)
        #expect(lhs.isLess(than: rhs) == isLess)
        #expect(lhs.isLessThanOrEqual(to: rhs) == isLessThanOrEqual)
        #expect(lhs.isGreater(than: rhs) == isGreater)
        #expect(lhs.isGreaterThanOrEqual(to: rhs) == isGreaterThanOrEqual)
    }
}

// MARK: - Positive Infinity

extension FractionComparableTests {
    @Test(
        "Positive infinity comparison follows rational rules",
        arguments: [
            (Fraction<Int>.infinity, Fraction<Int>.infinity, false, true, false, true),
            (Fraction<Int>.infinity, Fraction<Int>(1, 1), false, false, true, true),
            (Fraction<Int>.infinity, Fraction<Int>.negativeInfinity, false, false, true, true)
        ]
    )
    internal func positiveInfinityComparisonFollowsRationalRules(
        lhs: Fraction<Int>,
        rhs: Fraction<Int>,
        isLess: Bool,
        isLessThanOrEqual: Bool,
        isGreater: Bool,
        isGreaterThanOrEqual: Bool
    ) {
        #expect((lhs < rhs) == isLess)
        #expect((lhs <= rhs) == isLessThanOrEqual)
        #expect((lhs > rhs) == isGreater)
        #expect((lhs >= rhs) == isGreaterThanOrEqual)
        #expect(lhs.isLess(than: rhs) == isLess)
        #expect(lhs.isLessThanOrEqual(to: rhs) == isLessThanOrEqual)
        #expect(lhs.isGreater(than: rhs) == isGreater)
        #expect(lhs.isGreaterThanOrEqual(to: rhs) == isGreaterThanOrEqual)
    }
}

// MARK: - Positive Zero

extension FractionComparableTests {
    @Test(
        "Positive zero comparison follows stored representation rules",
        arguments: [
            (Fraction<Int>.zero, Fraction<Int>.zero, false, true, false, true),
            (Fraction<Int>.zero, Fraction<Int>.negativeZero, false, false, true, true),
            (Fraction<Int>.zero, Fraction<Int>(1, 1), true, true, false, false),
            (Fraction<Int>.zero, Fraction<Int>(-1, 1), false, false, true, true)
        ]
    )
    internal func positiveZeroComparisonFollowsStoredRepresentationRules(
        lhs: Fraction<Int>,
        rhs: Fraction<Int>,
        isLess: Bool,
        isLessThanOrEqual: Bool,
        isGreater: Bool,
        isGreaterThanOrEqual: Bool
    ) {
        #expect((lhs < rhs) == isLess)
        #expect((lhs <= rhs) == isLessThanOrEqual)
        #expect((lhs > rhs) == isGreater)
        #expect((lhs >= rhs) == isGreaterThanOrEqual)
        #expect(lhs.isLess(than: rhs) == isLess)
        #expect(lhs.isLessThanOrEqual(to: rhs) == isLessThanOrEqual)
        #expect(lhs.isGreater(than: rhs) == isGreater)
        #expect(lhs.isGreaterThanOrEqual(to: rhs) == isGreaterThanOrEqual)
    }
}
