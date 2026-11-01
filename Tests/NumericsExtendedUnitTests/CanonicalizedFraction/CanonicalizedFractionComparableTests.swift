// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Canonicalized Fraction Comparable Tests")
internal struct CanonicalizedFractionComparableTests {
    internal init() {}

    private static let comparisonArguments: [(Fraction<Int>, Fraction<Int>, Bool, Bool, Bool, Bool)] = [
        (Fraction<Int>(1, 2), Fraction<Int>(1, 2), false, true, false, true),
        (Fraction<Int>(1, 2), Fraction<Int>(2, 4), false, true, false, true),
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
        let lhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: lhs)
        let rhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: rhs)
        let lessThanResult: Bool = lhsWrapper < rhsWrapper
        #expect(lessThanResult == isLessExpected)
        let isLessResult: Bool = try lhsWrapper.isLess(than: rhsWrapper)
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
        let lhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: lhs)
        let rhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: rhs)
        let lessThanOrEqualResult: Bool = lhsWrapper <= rhsWrapper
        #expect(lessThanOrEqualResult == isLessThanOrEqualExpected)
        let isLessThanOrEqualResult: Bool = try lhsWrapper.isLessThanOrEqual(to: rhsWrapper)
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
        let lhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: lhs)
        let rhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: rhs)
        let greaterThanResult: Bool = lhsWrapper > rhsWrapper
        #expect(greaterThanResult == isGreaterExpected)
        let isGreaterResult: Bool = try lhsWrapper.isGreater(than: rhsWrapper)
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
        let lhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: lhs)
        let rhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: rhs)
        let greaterThanOrEqualResult: Bool = lhsWrapper >= rhsWrapper
        #expect(greaterThanOrEqualResult == isGreaterThanOrEqualExpected)
        let isGreaterThanOrEqualResult: Bool = try lhsWrapper.isGreaterThanOrEqual(to: rhsWrapper)
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
        let valueWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: value)
        let lowerBoundWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: lowerBound)
        let upperBoundWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: upperBound)
        let range: ClosedRange<Canonicalized<Fraction<Int>>> = lowerBoundWrapper ... upperBoundWrapper
        let result: Bool = try valueWrapper.isWithin(range)
        #expect(result == range.contains(valueWrapper))
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
        let valueWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: value)
        let lowerBoundWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: lowerBound)
        let upperBoundWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: upperBound)
        let result: Bool = try valueWrapper.isWithin(lowerBoundWrapper, upperBoundWrapper) == true
        #expect(result == (valueWrapper >= lowerBoundWrapper && valueWrapper <= upperBoundWrapper))
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
        let valueWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: value)
        let lowerBoundWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: lowerBound)
        let upperBoundWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: upperBound)
        let result: Bool = try valueWrapper.isBetween(lowerBoundWrapper, upperBoundWrapper) == true
        #expect(result == (valueWrapper > lowerBoundWrapper && valueWrapper < upperBoundWrapper))
    }
}

// MARK: - NaN

extension CanonicalizedFractionComparableTests {
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
        let lhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: lhs)
        let rhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: rhs)
        let lessThanResult: Bool = lhsWrapper < rhsWrapper
        #expect(lessThanResult == false)
        let lessThanOrEqualResult: Bool = lhsWrapper <= rhsWrapper
        #expect(lessThanOrEqualResult == false)
        let greaterThanResult: Bool = lhsWrapper > rhsWrapper
        #expect(greaterThanResult == false)
        let greaterThanOrEqualResult: Bool = lhsWrapper >= rhsWrapper
        #expect(greaterThanOrEqualResult == false)
        let isLessResult: Bool = try lhsWrapper.isLess(than: rhsWrapper)
        #expect(isLessResult == false)
        let isLessThanOrEqualResult: Bool = try lhsWrapper.isLessThanOrEqual(to: rhsWrapper)
        #expect(isLessThanOrEqualResult == false)
        let isGreaterResult: Bool = try lhsWrapper.isGreater(than: rhsWrapper)
        #expect(isGreaterResult == false)
        let isGreaterThanOrEqualResult: Bool = try lhsWrapper.isGreaterThanOrEqual(to: rhsWrapper)
        #expect(isGreaterThanOrEqualResult == false)
    }
}

// MARK: - Negative Infinity

extension CanonicalizedFractionComparableTests {
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
        let lhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: lhs)
        let rhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: rhs)
        let lessThanResult: Bool = lhsWrapper < rhsWrapper
        #expect(lessThanResult == isLessExpected)
        let lessThanOrEqualResult: Bool = lhsWrapper <= rhsWrapper
        #expect(lessThanOrEqualResult == isLessThanOrEqualExpected)
        let greaterThanResult: Bool = lhsWrapper > rhsWrapper
        #expect(greaterThanResult == isGreaterExpected)
        let greaterThanOrEqualResult: Bool = lhsWrapper >= rhsWrapper
        #expect(greaterThanOrEqualResult == isGreaterThanOrEqualExpected)
        let isLessResult: Bool = try lhsWrapper.isLess(than: rhsWrapper)
        #expect(isLessResult == isLessExpected)
        let isLessThanOrEqualResult: Bool = try lhsWrapper.isLessThanOrEqual(to: rhsWrapper)
        #expect(isLessThanOrEqualResult == isLessThanOrEqualExpected)
        let isGreaterResult: Bool = try lhsWrapper.isGreater(than: rhsWrapper)
        #expect(isGreaterResult == isGreaterExpected)
        let isGreaterThanOrEqualResult: Bool = try lhsWrapper.isGreaterThanOrEqual(to: rhsWrapper)
        #expect(isGreaterThanOrEqualResult == isGreaterThanOrEqualExpected)
    }
}

// MARK: - Negative Zero

extension CanonicalizedFractionComparableTests {
    @Test(
        "Negative zero comparison follows rational rules",
        arguments: [
            (Fraction<Int>.negativeZero, Fraction<Int>.negativeZero, false, true, false, true),
            (Fraction<Int>.negativeZero, Fraction<Int>.zero, false, true, false, true),
            (Fraction<Int>.negativeZero, Fraction<Int>(1, 1), true, true, false, false),
            (Fraction<Int>.negativeZero, Fraction<Int>(-1, 1), false, false, true, true)
        ]
    )
    internal func negativeZeroComparisonFollowsRationalRules(
        lhs: Fraction<Int>,
        rhs: Fraction<Int>,
        isLessExpected: Bool,
        isLessThanOrEqualExpected: Bool,
        isGreaterExpected: Bool,
        isGreaterThanOrEqualExpected: Bool
    ) throws {
        let lhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: lhs)
        let rhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: rhs)
        let lessThanResult: Bool = lhsWrapper < rhsWrapper
        #expect(lessThanResult == isLessExpected)
        let lessThanOrEqualResult: Bool = lhsWrapper <= rhsWrapper
        #expect(lessThanOrEqualResult == isLessThanOrEqualExpected)
        let greaterThanResult: Bool = lhsWrapper > rhsWrapper
        #expect(greaterThanResult == isGreaterExpected)
        let greaterThanOrEqualResult: Bool = lhsWrapper >= rhsWrapper
        #expect(greaterThanOrEqualResult == isGreaterThanOrEqualExpected)
        let isLessResult: Bool = try lhsWrapper.isLess(than: rhsWrapper)
        #expect(isLessResult == isLessExpected)
        let isLessThanOrEqualResult: Bool = try lhsWrapper.isLessThanOrEqual(to: rhsWrapper)
        #expect(isLessThanOrEqualResult == isLessThanOrEqualExpected)
        let isGreaterResult: Bool = try lhsWrapper.isGreater(than: rhsWrapper)
        #expect(isGreaterResult == isGreaterExpected)
        let isGreaterThanOrEqualResult: Bool = try lhsWrapper.isGreaterThanOrEqual(to: rhsWrapper)
        #expect(isGreaterThanOrEqualResult == isGreaterThanOrEqualExpected)
    }
}

// MARK: - Positive Infinity

extension CanonicalizedFractionComparableTests {
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
        let lhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: lhs)
        let rhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: rhs)
        let lessThanResult: Bool = lhsWrapper < rhsWrapper
        #expect(lessThanResult == isLessExpected)
        let lessThanOrEqualResult: Bool = lhsWrapper <= rhsWrapper
        #expect(lessThanOrEqualResult == isLessThanOrEqualExpected)
        let greaterThanResult: Bool = lhsWrapper > rhsWrapper
        #expect(greaterThanResult == isGreaterExpected)
        let greaterThanOrEqualResult: Bool = lhsWrapper >= rhsWrapper
        #expect(greaterThanOrEqualResult == isGreaterThanOrEqualExpected)
        let isLessResult: Bool = try lhsWrapper.isLess(than: rhsWrapper)
        #expect(isLessResult == isLessExpected)
        let isLessThanOrEqualResult: Bool = try lhsWrapper.isLessThanOrEqual(to: rhsWrapper)
        #expect(isLessThanOrEqualResult == isLessThanOrEqualExpected)
        let isGreaterResult: Bool = try lhsWrapper.isGreater(than: rhsWrapper)
        #expect(isGreaterResult == isGreaterExpected)
        let isGreaterThanOrEqualResult: Bool = try lhsWrapper.isGreaterThanOrEqual(to: rhsWrapper)
        #expect(isGreaterThanOrEqualResult == isGreaterThanOrEqualExpected)
    }
}

// MARK: - Positive Zero

extension CanonicalizedFractionComparableTests {
    @Test(
        "Positive zero comparison follows rational rules",
        arguments: [
            (Fraction<Int>.zero, Fraction<Int>.zero, false, true, false, true),
            (Fraction<Int>.zero, Fraction<Int>.negativeZero, false, true, false, true),
            (Fraction<Int>.zero, Fraction<Int>(1, 1), true, true, false, false),
            (Fraction<Int>.zero, Fraction<Int>(-1, 1), false, false, true, true)
        ]
    )
    internal func positiveZeroComparisonFollowsRationalRules(
        lhs: Fraction<Int>,
        rhs: Fraction<Int>,
        isLessExpected: Bool,
        isLessThanOrEqualExpected: Bool,
        isGreaterExpected: Bool,
        isGreaterThanOrEqualExpected: Bool
    ) throws {
        let lhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: lhs)
        let rhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: rhs)
        let lessThanResult: Bool = lhsWrapper < rhsWrapper
        #expect(lessThanResult == isLessExpected)
        let lessThanOrEqualResult: Bool = lhsWrapper <= rhsWrapper
        #expect(lessThanOrEqualResult == isLessThanOrEqualExpected)
        let greaterThanResult: Bool = lhsWrapper > rhsWrapper
        #expect(greaterThanResult == isGreaterExpected)
        let greaterThanOrEqualResult: Bool = lhsWrapper >= rhsWrapper
        #expect(greaterThanOrEqualResult == isGreaterThanOrEqualExpected)
        let isLessResult: Bool = try lhsWrapper.isLess(than: rhsWrapper)
        #expect(isLessResult == isLessExpected)
        let isLessThanOrEqualResult: Bool = try lhsWrapper.isLessThanOrEqual(to: rhsWrapper)
        #expect(isLessThanOrEqualResult == isLessThanOrEqualExpected)
        let isGreaterResult: Bool = try lhsWrapper.isGreater(than: rhsWrapper)
        #expect(isGreaterResult == isGreaterExpected)
        let isGreaterThanOrEqualResult: Bool = try lhsWrapper.isGreaterThanOrEqual(to: rhsWrapper)
        #expect(isGreaterThanOrEqualResult == isGreaterThanOrEqualExpected)
    }
}
