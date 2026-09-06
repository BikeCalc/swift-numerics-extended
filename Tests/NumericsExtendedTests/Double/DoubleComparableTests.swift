// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Double Comparable Tests")
internal struct DoubleComparableTests {
    private static let comparisonArguments: Array<(Double, Double, Bool, Bool, Bool, Bool)> = [
        (1.0, 1.0, false, true, false, true),
        (-1.0, -1.0, false, true, false, true),
        (2.0, 3.0, true, true, false, false),
        (3.0, 2.0, false, false, true, true),
        (-2.0, 3.0, true, true, false, false),
        (-3.0, -2.0, true, true, false, false),
        (0.5, 1.5, true, true, false, false),
        (1.5, 0.5, false, false, true, true),
        (-0.5, 1.5, true, true, false, false),
        (-1.5, -0.5, true, true, false, false)
    ]

    private static let rangeArguments: Array<(Double, Double, Double)> = [
        (1.0, 2.0, 4.0),
        (2.0, 2.0, 4.0),
        (3.0, 2.0, 4.0),
        (4.0, 2.0, 4.0),
        (5.0, 2.0, 4.0),
        (-5.0, -4.0, -2.0),
        (-4.0, -4.0, -2.0),
        (-3.0, -4.0, -2.0),
        (-2.0, -4.0, -2.0),
        (-1.0, -4.0, -2.0),
        (0.5, 1.0, 2.0),
        (1.0, 1.0, 2.0),
        (1.5, 1.0, 2.0),
        (2.0, 1.0, 2.0),
        (2.5, 1.0, 2.0),
        (-2.5, -2.0, -1.0),
        (-2.0, -2.0, -1.0),
        (-1.5, -2.0, -1.0),
        (-1.0, -2.0, -1.0),
        (-0.5, -2.0, -1.0)
    ]

    @Test(
        "Is less than",
        arguments: Self.comparisonArguments
    )
    internal func isLessThan(
        lhs: Double,
        rhs: Double,
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
        lhs: Double,
        rhs: Double,
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
        lhs: Double,
        rhs: Double,
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
        lhs: Double,
        rhs: Double,
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
        value: Double,
        lowerBound: Double,
        upperBound: Double
    ) {
        let range: ClosedRange<Double> = lowerBound ... upperBound
        #expect(value.isWithin(range) == range.contains(value))
    }

    @Test(
        "Is within bounds",
        arguments: Self.rangeArguments
    )
    internal func isWithinBounds(
        value: Double,
        lowerBound: Double,
        upperBound: Double
    ) {
        let isWithin: Bool = value.isWithin(
            lowerBound,
            through: upperBound
        ) == true
        #expect(isWithin == (value >= lowerBound && value <= upperBound))
    }

    @Test(
        "Is between bounds",
        arguments: Self.rangeArguments
    )
    internal func isBetweenBounds(
        value: Double,
        lowerBound: Double,
        upperBound: Double
    ) {
        let isBetween: Bool = value.isBetween(
            lowerBound,
            and: upperBound
        ) == true
        #expect(isBetween == (value > lowerBound && value < upperBound))
    }
}

// MARK: - NaN

extension DoubleComparableTests {
    @Test(
        "NaN comparison follows floating-point rules",
        arguments: [
            (Double.nan, 1.0),
            (1.0, Double.nan),
            (Double.nan, Double.nan)
        ]
    )
    internal func nanComparisonFollowsFloatingPointRules(
        lhs: Double,
        rhs: Double
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

extension DoubleComparableTests {
    @Test(
        "Negative infinity comparison follows floating-point rules",
        arguments: [
            (Double.negativeInfinity, Double.negativeInfinity, false, true, false, true),
            (Double.negativeInfinity, -1.0, true, true, false, false),
            (Double.negativeInfinity, Double.infinity, true, true, false, false)
        ]
    )
    internal func negativeInfinityComparisonFollowsFloatingPointRules(
        lhs: Double,
        rhs: Double,
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

extension DoubleComparableTests {
    @Test(
        "Negative zero comparison follows floating-point rules",
        arguments: [
            (Double.negativeZero, Double.negativeZero, false, true, false, true),
            (Double.negativeZero, Double.zero, false, true, false, true),
            (Double.negativeZero, -1.0, false, false, true, true)
        ]
    )
    internal func negativeZeroComparisonFollowsFloatingPointRules(
        lhs: Double,
        rhs: Double,
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

extension DoubleComparableTests {
    @Test(
        "Positive infinity comparison follows floating-point rules",
        arguments: [
            (Double.infinity, Double.infinity, false, true, false, true),
            (Double.infinity, 1.0, false, false, true, true),
            (Double.infinity, Double.negativeInfinity, false, false, true, true)
        ]
    )
    internal func positiveInfinityComparisonFollowsFloatingPointRules(
        lhs: Double,
        rhs: Double,
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

extension DoubleComparableTests {
    @Test(
        "Positive zero comparison follows floating-point rules",
        arguments: [
            (Double.zero, Double.zero, false, true, false, true),
            (Double.zero, Double.negativeZero, false, true, false, true),
            (Double.zero, 1.0, true, true, false, false)
        ]
    )
    internal func positiveZeroComparisonFollowsFloatingPointRules(
        lhs: Double,
        rhs: Double,
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
