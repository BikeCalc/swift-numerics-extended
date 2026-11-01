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
    internal init() {}

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
        isLessExpected: Bool,
        isLessThanOrEqualExpected _: Bool,
        isGreaterExpected _: Bool,
        isGreaterThanOrEqualExpected _: Bool
    ) throws {
        let lessThanResult: Bool = lhs < rhs
        #expect(lessThanResult == isLessExpected)
        let isLessResult: Bool = lhs.isLess(than: rhs)
        #expect(isLessResult == isLessExpected)
    }

    @Test(
        "Is less than or equal",
        arguments: Self.comparisonArguments
    )
    internal func isLessThanOrEqualTo(
        lhs: Double,
        rhs: Double,
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
        lhs: Double,
        rhs: Double,
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
        lhs: Double,
        rhs: Double,
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
        value: Double,
        lowerBound: Double,
        upperBound: Double
    ) throws {
        let range: ClosedRange<Double> = lowerBound ... upperBound
        let result: Bool = try value.isWithin(range)
        #expect(result == range.contains(value))
    }

    @Test(
        "Is within bounds",
        arguments: Self.rangeArguments
    )
    internal func isWithinBounds(
        value: Double,
        lowerBound: Double,
        upperBound: Double
    ) throws {
        let result: Bool = try value.isWithin(lowerBound, upperBound) == true
        #expect(result == (value >= lowerBound && value <= upperBound))
    }

    @Test(
        "Is between bounds",
        arguments: Self.rangeArguments
    )
    internal func isBetweenBounds(
        value: Double,
        lowerBound: Double,
        upperBound: Double
    ) throws {
        let result: Bool = try value.isBetween(lowerBound, upperBound) == true
        #expect(result == (value > lowerBound && value < upperBound))
    }
}

// MARK: - NaN

extension DoubleComparableTests {
    @Test("NaN is outside ordered bounds")
    internal func nanIsOutsideOrderedBounds() throws {
        let firstResult: Bool = try Double.nan.isWithin(1.0 ... 2.0)
        #expect(firstResult == false)
        let secondResult: Bool = try Double.nan.isWithin(1.0, 2.0)
        #expect(secondResult == false)
        let isBetweenResult: Bool = try Double.nan.isBetween(1.0, 2.0)
        #expect(isBetweenResult == false)
    }

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
    ) throws {
        let lessThanResult: Bool = lhs < rhs
        #expect(lessThanResult == false)
        let greaterThanResult: Bool = lhs > rhs
        #expect(greaterThanResult == false)
        let lessThanOrEqualResult: Bool = lhs <= rhs
        #expect(lessThanOrEqualResult == false)
        let greaterThanOrEqualResult: Bool = lhs >= rhs
        #expect(greaterThanOrEqualResult == false)
        let isLessResult: Bool = lhs.isLess(than: rhs)
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
        let isLessResult: Bool = lhs.isLess(than: rhs)
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
        let isLessResult: Bool = lhs.isLess(than: rhs)
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
        let isLessResult: Bool = lhs.isLess(than: rhs)
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
        let isLessResult: Bool = lhs.isLess(than: rhs)
        #expect(isLessResult == isLessExpected)
        let isLessThanOrEqualResult: Bool = try lhs.isLessThanOrEqual(to: rhs)
        #expect(isLessThanOrEqualResult == isLessThanOrEqualExpected)
        let isGreaterResult: Bool = try lhs.isGreater(than: rhs)
        #expect(isGreaterResult == isGreaterExpected)
        let isGreaterThanOrEqualResult: Bool = try lhs.isGreaterThanOrEqual(to: rhs)
        #expect(isGreaterThanOrEqualResult == isGreaterThanOrEqualExpected)
    }
}
