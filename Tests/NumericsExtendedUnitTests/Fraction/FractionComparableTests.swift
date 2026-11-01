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
    internal init() {}

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
        isLessExpected: Bool,
        isLessThanOrEqualExpected _: Bool,
        isGreaterExpected _: Bool,
        isGreaterThanOrEqualExpected _: Bool
    ) throws {
        let lessThanResult: Bool = lhs < rhs
        #expect(lessThanResult == isLessExpected)
        let isLessResult: Bool = try lhs.isLess(than: rhs)
        #expect(isLessResult == isLessExpected)
    }

    @Test(
        "Is less than or equal",
        arguments: Self.comparisonArguments
    )
    internal func isLessThanOrEqualTo(
        lhs: Fraction<Int>,
        rhs: Fraction<Int>,
        isLessExpected _: Bool,
        isLessThanOrEqualExpected: Bool,
        isGreaterExpected _: Bool,
        isGreaterThanOrEqualExpected _: Bool
    ) throws {
        let lessThanOrEqualResult: Bool = lhs <= rhs
        #expect(lessThanOrEqualResult == isLessThanOrEqualExpected)
        let isLessThanOrEqualResult: Bool = try lhs.isLessThanOrEqual(to: rhs)
        #expect(isLessThanOrEqualResult == isLessThanOrEqualExpected)
    }

    @Test(
        "Is greater than",
        arguments: Self.comparisonArguments
    )
    internal func isGreaterThan(
        lhs: Fraction<Int>,
        rhs: Fraction<Int>,
        isLessExpected _: Bool,
        isLessThanOrEqualExpected _: Bool,
        isGreaterExpected: Bool,
        isGreaterThanOrEqualExpected _: Bool
    ) throws {
        let greaterThanResult: Bool = lhs > rhs
        #expect(greaterThanResult == isGreaterExpected)
        let isGreaterResult: Bool = try lhs.isGreater(than: rhs)
        #expect(isGreaterResult == isGreaterExpected)
    }

    @Test(
        "Is greater than or equal",
        arguments: Self.comparisonArguments
    )
    internal func isGreaterThanOrEqualTo(
        lhs: Fraction<Int>,
        rhs: Fraction<Int>,
        isLessExpected _: Bool,
        isLessThanOrEqualExpected _: Bool,
        isGreaterExpected _: Bool,
        isGreaterThanOrEqualExpected: Bool
    ) throws {
        let greaterThanOrEqualResult: Bool = lhs >= rhs
        #expect(greaterThanOrEqualResult == isGreaterThanOrEqualExpected)
        let isGreaterThanOrEqualResult: Bool = try lhs.isGreaterThanOrEqual(to: rhs)
        #expect(isGreaterThanOrEqualResult == isGreaterThanOrEqualExpected)
    }

    @Test(
        "Is within closed range",
        arguments: Self.rangeArguments
    )
    internal func isWithinClosedRange(
        value: Fraction<Int>,
        lowerBound: Fraction<Int>,
        upperBound: Fraction<Int>
    ) throws {
        let range: ClosedRange<Fraction<Int>> = lowerBound ... upperBound
        let result: Bool = try value.isWithin(range)
        #expect(result == range.contains(value))
    }

    @Test(
        "Is within bounds",
        arguments: Self.rangeArguments
    )
    internal func isWithinBounds(
        value: Fraction<Int>,
        lowerBound: Fraction<Int>,
        upperBound: Fraction<Int>
    ) throws {
        let result: Bool = try value.isWithin(lowerBound, upperBound) == true
        #expect(result == (value >= lowerBound && value <= upperBound))
    }

    @Test(
        "Is between bounds",
        arguments: Self.rangeArguments
    )
    internal func isBetweenBounds(
        value: Fraction<Int>,
        lowerBound: Fraction<Int>,
        upperBound: Fraction<Int>
    ) throws {
        let result: Bool = try value.isBetween(lowerBound, upperBound) == true
        #expect(result == (value > lowerBound && value < upperBound))
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
    ) throws {
        let lessThanResult: Bool = lhs < rhs
        #expect(lessThanResult == false)
        let greaterThanResult: Bool = lhs > rhs
        #expect(greaterThanResult == false)
        let lessThanOrEqualResult: Bool = lhs <= rhs
        #expect(lessThanOrEqualResult == false)
        let greaterThanOrEqualResult: Bool = lhs >= rhs
        #expect(greaterThanOrEqualResult == false)
        let isLessResult: Bool = try lhs.isLess(than: rhs)
        #expect(isLessResult == false)
        let isLessThanOrEqualResult: Bool = try lhs.isLessThanOrEqual(to: rhs)
        #expect(isLessThanOrEqualResult == false)
        let isGreaterResult: Bool = try lhs.isGreater(than: rhs)
        #expect(isGreaterResult == false)
        let isGreaterThanOrEqualResult: Bool = try lhs.isGreaterThanOrEqual(to: rhs)
        #expect(isGreaterThanOrEqualResult == false)
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
        isLessExpected: Bool,
        isLessThanOrEqualExpected: Bool,
        isGreaterExpected: Bool,
        isGreaterThanOrEqualExpected: Bool
    ) throws {
        let lessThanResult: Bool = lhs < rhs
        #expect(lessThanResult == isLessExpected)
        let lessThanOrEqualResult: Bool = lhs <= rhs
        #expect(lessThanOrEqualResult == isLessThanOrEqualExpected)
        let greaterThanResult: Bool = lhs > rhs
        #expect(greaterThanResult == isGreaterExpected)
        let greaterThanOrEqualResult: Bool = lhs >= rhs
        #expect(greaterThanOrEqualResult == isGreaterThanOrEqualExpected)
        let isLessResult: Bool = try lhs.isLess(than: rhs)
        #expect(isLessResult == isLessExpected)
        let isLessThanOrEqualResult: Bool = try lhs.isLessThanOrEqual(to: rhs)
        #expect(isLessThanOrEqualResult == isLessThanOrEqualExpected)
        let isGreaterResult: Bool = try lhs.isGreater(than: rhs)
        #expect(isGreaterResult == isGreaterExpected)
        let isGreaterThanOrEqualResult: Bool = try lhs.isGreaterThanOrEqual(to: rhs)
        #expect(isGreaterThanOrEqualResult == isGreaterThanOrEqualExpected)
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
        isLessExpected: Bool,
        isLessThanOrEqualExpected: Bool,
        isGreaterExpected: Bool,
        isGreaterThanOrEqualExpected: Bool
    ) throws {
        let lessThanResult: Bool = lhs < rhs
        #expect(lessThanResult == isLessExpected)
        let lessThanOrEqualResult: Bool = lhs <= rhs
        #expect(lessThanOrEqualResult == isLessThanOrEqualExpected)
        let greaterThanResult: Bool = lhs > rhs
        #expect(greaterThanResult == isGreaterExpected)
        let greaterThanOrEqualResult: Bool = lhs >= rhs
        #expect(greaterThanOrEqualResult == isGreaterThanOrEqualExpected)
        let isLessResult: Bool = try lhs.isLess(than: rhs)
        #expect(isLessResult == isLessExpected)
        let isLessThanOrEqualResult: Bool = try lhs.isLessThanOrEqual(to: rhs)
        #expect(isLessThanOrEqualResult == isLessThanOrEqualExpected)
        let isGreaterResult: Bool = try lhs.isGreater(than: rhs)
        #expect(isGreaterResult == isGreaterExpected)
        let isGreaterThanOrEqualResult: Bool = try lhs.isGreaterThanOrEqual(to: rhs)
        #expect(isGreaterThanOrEqualResult == isGreaterThanOrEqualExpected)
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
        isLessExpected: Bool,
        isLessThanOrEqualExpected: Bool,
        isGreaterExpected: Bool,
        isGreaterThanOrEqualExpected: Bool
    ) throws {
        let lessThanResult: Bool = lhs < rhs
        #expect(lessThanResult == isLessExpected)
        let lessThanOrEqualResult: Bool = lhs <= rhs
        #expect(lessThanOrEqualResult == isLessThanOrEqualExpected)
        let greaterThanResult: Bool = lhs > rhs
        #expect(greaterThanResult == isGreaterExpected)
        let greaterThanOrEqualResult: Bool = lhs >= rhs
        #expect(greaterThanOrEqualResult == isGreaterThanOrEqualExpected)
        let isLessResult: Bool = try lhs.isLess(than: rhs)
        #expect(isLessResult == isLessExpected)
        let isLessThanOrEqualResult: Bool = try lhs.isLessThanOrEqual(to: rhs)
        #expect(isLessThanOrEqualResult == isLessThanOrEqualExpected)
        let isGreaterResult: Bool = try lhs.isGreater(than: rhs)
        #expect(isGreaterResult == isGreaterExpected)
        let isGreaterThanOrEqualResult: Bool = try lhs.isGreaterThanOrEqual(to: rhs)
        #expect(isGreaterThanOrEqualResult == isGreaterThanOrEqualExpected)
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
        isLessExpected: Bool,
        isLessThanOrEqualExpected: Bool,
        isGreaterExpected: Bool,
        isGreaterThanOrEqualExpected: Bool
    ) throws {
        let lessThanResult: Bool = lhs < rhs
        #expect(lessThanResult == isLessExpected)
        let lessThanOrEqualResult: Bool = lhs <= rhs
        #expect(lessThanOrEqualResult == isLessThanOrEqualExpected)
        let greaterThanResult: Bool = lhs > rhs
        #expect(greaterThanResult == isGreaterExpected)
        let greaterThanOrEqualResult: Bool = lhs >= rhs
        #expect(greaterThanOrEqualResult == isGreaterThanOrEqualExpected)
        let isLessResult: Bool = try lhs.isLess(than: rhs)
        #expect(isLessResult == isLessExpected)
        let isLessThanOrEqualResult: Bool = try lhs.isLessThanOrEqual(to: rhs)
        #expect(isLessThanOrEqualResult == isLessThanOrEqualExpected)
        let isGreaterResult: Bool = try lhs.isGreater(than: rhs)
        #expect(isGreaterResult == isGreaterExpected)
        let isGreaterThanOrEqualResult: Bool = try lhs.isGreaterThanOrEqual(to: rhs)
        #expect(isGreaterThanOrEqualResult == isGreaterThanOrEqualExpected)
    }
}
