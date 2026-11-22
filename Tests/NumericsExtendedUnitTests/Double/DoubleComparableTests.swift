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
    ) {
        let lessThanResult: Bool = lhs < rhs
        #expect(lessThanResult == isLessExpected)
        let isLessResult: Bool = Self.genericIsLess(lhs, rhs)
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
    ) {
        let lessThanOrEqualResult: Bool = lhs <= rhs
        #expect(lessThanOrEqualResult == isLessThanOrEqualExpected)
        let isLessThanOrEqualResult: Bool = lhs.isLessThanOrEqual(to: rhs)
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
    ) {
        let greaterThanResult: Bool = lhs > rhs
        #expect(greaterThanResult == isGreaterExpected)
        let isGreaterResult: Bool = lhs.isGreater(than: rhs)
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
    ) {
        let greaterThanOrEqualResult: Bool = lhs >= rhs
        #expect(greaterThanOrEqualResult == isGreaterThanOrEqualExpected)
        let isGreaterThanOrEqualResult: Bool = lhs.isGreaterThanOrEqual(to: rhs)
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
    ) {
        let range: ClosedRange<Double> = lowerBound ... upperBound
        let result: Bool = value.isWithin(range)
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
    ) {
        let result: Bool = value.isWithin(lowerBound, upperBound) == true
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
    ) {
        let result: Bool = value.isBetween(lowerBound, upperBound) == true
        #expect(result == (value > lowerBound && value < upperBound))
    }
}

// MARK: - NaN

extension DoubleComparableTests {
    @Test("NaN is outside ordered bounds")
    internal func nanIsOutsideOrderedBounds() {
        let firstResult: Bool = Double.nan.isWithin(1.0 ... 2.0)
        #expect(firstResult == false)
        let secondResult: Bool = Double.nan.isWithin(1.0, 2.0)
        #expect(secondResult == false)
        let isBetweenResult: Bool = Double.nan.isBetween(1.0, 2.0)
        #expect(isBetweenResult == false)
    }

    @Test(
        "NaN comparison follows floating-point rules",
        arguments: [
            (.nan, 1.0),
            (1.0, .nan),
            (.nan, .nan)
        ] as Array<(Double, Double)>
    )
    internal func nanComparisonFollowsFloatingPointRules(
        lhs: Double,
        rhs: Double
    ) {
        let lessThanResult: Bool = lhs < rhs
        #expect(lessThanResult == false)
        let greaterThanResult: Bool = lhs > rhs
        #expect(greaterThanResult == false)
        let lessThanOrEqualResult: Bool = lhs <= rhs
        #expect(lessThanOrEqualResult == false)
        let greaterThanOrEqualResult: Bool = lhs >= rhs
        #expect(greaterThanOrEqualResult == false)
        let isLessResult: Bool = Self.genericIsLess(lhs, rhs)
        #expect(isLessResult == false)
        let isLessThanOrEqualResult: Bool = lhs.isLessThanOrEqual(to: rhs)
        #expect(isLessThanOrEqualResult == false)
        let isGreaterResult: Bool = lhs.isGreater(than: rhs)
        #expect(isGreaterResult == false)
        let isGreaterThanOrEqualResult: Bool = lhs.isGreaterThanOrEqual(to: rhs)
        #expect(isGreaterThanOrEqualResult == false)
    }
}

// MARK: - Negative Infinity

extension DoubleComparableTests {
    @Test(
        "Negative infinity comparison follows floating-point rules",
        arguments: [
            (.negativeInfinity, .negativeInfinity, false, true, false, true),
            (.negativeInfinity, -1.0, true, true, false, false),
            (.negativeInfinity, .infinity, true, true, false, false)
        ] as Array<(Double, Double, Bool, Bool, Bool, Bool)>
    )
    internal func negativeInfinityComparisonFollowsFloatingPointRules(
        lhs: Double,
        rhs: Double,
        isLessExpected: Bool,
        isLessThanOrEqualExpected: Bool,
        isGreaterExpected: Bool,
        isGreaterThanOrEqualExpected: Bool
    ) {
        let lessThanResult: Bool = lhs < rhs
        #expect(lessThanResult == isLessExpected)
        let lessThanOrEqualResult: Bool = lhs <= rhs
        #expect(lessThanOrEqualResult == isLessThanOrEqualExpected)
        let greaterThanResult: Bool = lhs > rhs
        #expect(greaterThanResult == isGreaterExpected)
        let greaterThanOrEqualResult: Bool = lhs >= rhs
        #expect(greaterThanOrEqualResult == isGreaterThanOrEqualExpected)
        let isLessResult: Bool = Self.genericIsLess(lhs, rhs)
        #expect(isLessResult == isLessExpected)
        let isLessThanOrEqualResult: Bool = lhs.isLessThanOrEqual(to: rhs)
        #expect(isLessThanOrEqualResult == isLessThanOrEqualExpected)
        let isGreaterResult: Bool = lhs.isGreater(than: rhs)
        #expect(isGreaterResult == isGreaterExpected)
        let isGreaterThanOrEqualResult: Bool = lhs.isGreaterThanOrEqual(to: rhs)
        #expect(isGreaterThanOrEqualResult == isGreaterThanOrEqualExpected)
    }
}

// MARK: - Negative Zero

extension DoubleComparableTests {
    @Test(
        "Negative zero comparison follows floating-point rules",
        arguments: [
            (.negativeZero, .negativeZero, false, true, false, true),
            (.negativeZero, .zero, false, true, false, true),
            (.negativeZero, -1.0, false, false, true, true)
        ] as Array<(Double, Double, Bool, Bool, Bool, Bool)>
    )
    internal func negativeZeroComparisonFollowsFloatingPointRules(
        lhs: Double,
        rhs: Double,
        isLessExpected: Bool,
        isLessThanOrEqualExpected: Bool,
        isGreaterExpected: Bool,
        isGreaterThanOrEqualExpected: Bool
    ) {
        let lessThanResult: Bool = lhs < rhs
        #expect(lessThanResult == isLessExpected)
        let lessThanOrEqualResult: Bool = lhs <= rhs
        #expect(lessThanOrEqualResult == isLessThanOrEqualExpected)
        let greaterThanResult: Bool = lhs > rhs
        #expect(greaterThanResult == isGreaterExpected)
        let greaterThanOrEqualResult: Bool = lhs >= rhs
        #expect(greaterThanOrEqualResult == isGreaterThanOrEqualExpected)
        let isLessResult: Bool = Self.genericIsLess(lhs, rhs)
        #expect(isLessResult == isLessExpected)
        let isLessThanOrEqualResult: Bool = lhs.isLessThanOrEqual(to: rhs)
        #expect(isLessThanOrEqualResult == isLessThanOrEqualExpected)
        let isGreaterResult: Bool = lhs.isGreater(than: rhs)
        #expect(isGreaterResult == isGreaterExpected)
        let isGreaterThanOrEqualResult: Bool = lhs.isGreaterThanOrEqual(to: rhs)
        #expect(isGreaterThanOrEqualResult == isGreaterThanOrEqualExpected)
    }
}

// MARK: - Positive Infinity

extension DoubleComparableTests {
    @Test(
        "Positive infinity comparison follows floating-point rules",
        arguments: [
            (.infinity, .infinity, false, true, false, true),
            (.infinity, 1.0, false, false, true, true),
            (.infinity, .negativeInfinity, false, false, true, true)
        ] as Array<(Double, Double, Bool, Bool, Bool, Bool)>
    )
    internal func positiveInfinityComparisonFollowsFloatingPointRules(
        lhs: Double,
        rhs: Double,
        isLessExpected: Bool,
        isLessThanOrEqualExpected: Bool,
        isGreaterExpected: Bool,
        isGreaterThanOrEqualExpected: Bool
    ) {
        let lessThanResult: Bool = lhs < rhs
        #expect(lessThanResult == isLessExpected)
        let lessThanOrEqualResult: Bool = lhs <= rhs
        #expect(lessThanOrEqualResult == isLessThanOrEqualExpected)
        let greaterThanResult: Bool = lhs > rhs
        #expect(greaterThanResult == isGreaterExpected)
        let greaterThanOrEqualResult: Bool = lhs >= rhs
        #expect(greaterThanOrEqualResult == isGreaterThanOrEqualExpected)
        let isLessResult: Bool = Self.genericIsLess(lhs, rhs)
        #expect(isLessResult == isLessExpected)
        let isLessThanOrEqualResult: Bool = lhs.isLessThanOrEqual(to: rhs)
        #expect(isLessThanOrEqualResult == isLessThanOrEqualExpected)
        let isGreaterResult: Bool = lhs.isGreater(than: rhs)
        #expect(isGreaterResult == isGreaterExpected)
        let isGreaterThanOrEqualResult: Bool = lhs.isGreaterThanOrEqual(to: rhs)
        #expect(isGreaterThanOrEqualResult == isGreaterThanOrEqualExpected)
    }
}

// MARK: - Positive Zero

extension DoubleComparableTests {
    @Test(
        "Positive zero comparison follows floating-point rules",
        arguments: [
            (.zero, .zero, false, true, false, true),
            (.zero, .negativeZero, false, true, false, true),
            (.zero, 1.0, true, true, false, false)
        ] as Array<(Double, Double, Bool, Bool, Bool, Bool)>
    )
    internal func positiveZeroComparisonFollowsFloatingPointRules(
        lhs: Double,
        rhs: Double,
        isLessExpected: Bool,
        isLessThanOrEqualExpected: Bool,
        isGreaterExpected: Bool,
        isGreaterThanOrEqualExpected: Bool
    ) {
        let lessThanResult: Bool = lhs < rhs
        #expect(lessThanResult == isLessExpected)
        let lessThanOrEqualResult: Bool = lhs <= rhs
        #expect(lessThanOrEqualResult == isLessThanOrEqualExpected)
        let greaterThanResult: Bool = lhs > rhs
        #expect(greaterThanResult == isGreaterExpected)
        let greaterThanOrEqualResult: Bool = lhs >= rhs
        #expect(greaterThanOrEqualResult == isGreaterThanOrEqualExpected)
        let isLessResult: Bool = Self.genericIsLess(lhs, rhs)
        #expect(isLessResult == isLessExpected)
        let isLessThanOrEqualResult: Bool = lhs.isLessThanOrEqual(to: rhs)
        #expect(isLessThanOrEqualResult == isLessThanOrEqualExpected)
        let isGreaterResult: Bool = lhs.isGreater(than: rhs)
        #expect(isGreaterResult == isGreaterExpected)
        let isGreaterThanOrEqualResult: Bool = lhs.isGreaterThanOrEqual(to: rhs)
        #expect(isGreaterThanOrEqualResult == isGreaterThanOrEqualExpected)
    }
}

extension DoubleComparableTests {
    private static func genericIsLess<Value>(
        _ lhs: Value,
        _ rhs: Value
    ) -> Bool
    where Value: Comparable {
        return lhs.isLess(than: rhs)
    }
}
