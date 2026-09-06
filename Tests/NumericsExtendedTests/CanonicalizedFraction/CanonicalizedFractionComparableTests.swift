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
        isLess: Bool,
        isLessThanOrEqual _: Bool,
        isGreater _: Bool,
        isGreaterThanOrEqual _: Bool
    ) {
        let lhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: lhs)
        let rhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: rhs)

        #expect((lhsWrapper < rhsWrapper) == isLess)
        #expect(lhsWrapper.isLess(than: rhsWrapper) == isLess)
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
        let lhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: lhs)
        let rhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: rhs)

        #expect((lhsWrapper <= rhsWrapper) == isLessThanOrEqual)
        #expect(lhsWrapper.isLessThanOrEqual(to: rhsWrapper) == isLessThanOrEqual)
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
        let lhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: lhs)
        let rhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: rhs)

        #expect((lhsWrapper > rhsWrapper) == isGreater)
        #expect(lhsWrapper.isGreater(than: rhsWrapper) == isGreater)
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
        let lhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: lhs)
        let rhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: rhs)

        #expect((lhsWrapper >= rhsWrapper) == isGreaterThanOrEqual)
        #expect(lhsWrapper.isGreaterThanOrEqual(to: rhsWrapper) == isGreaterThanOrEqual)
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
        let valueWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: value)
        let lowerBoundWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: lowerBound)
        let upperBoundWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: upperBound)
        let range: ClosedRange<Canonicalized<Fraction<Int>>> = lowerBoundWrapper ... upperBoundWrapper

        #expect(valueWrapper.isWithin(range) == range.contains(valueWrapper))
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
        let valueWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: value)
        let lowerBoundWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: lowerBound)
        let upperBoundWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: upperBound)
        let valueIsWithinBounds: Bool = valueWrapper.isWithin(lowerBoundWrapper, upperBoundWrapper) == true

        #expect(valueIsWithinBounds == (valueWrapper >= lowerBoundWrapper && valueWrapper <= upperBoundWrapper))
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
        let valueWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: value)
        let lowerBoundWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: lowerBound)
        let upperBoundWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: upperBound)
        let valueIsBetweenBounds: Bool = valueWrapper.isBetween(lowerBoundWrapper, upperBoundWrapper) == true

        #expect(valueIsBetweenBounds == (valueWrapper > lowerBoundWrapper && valueWrapper < upperBoundWrapper))
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
    ) {
        let lhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: lhs)
        let rhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: rhs)

        #expect((lhsWrapper < rhsWrapper) == false)
        #expect((lhsWrapper <= rhsWrapper) == false)
        #expect((lhsWrapper > rhsWrapper) == false)
        #expect((lhsWrapper >= rhsWrapper) == false)
        #expect(lhsWrapper.isLess(than: rhsWrapper) == false)
        #expect(lhsWrapper.isLessThanOrEqual(to: rhsWrapper) == false)
        #expect(lhsWrapper.isGreater(than: rhsWrapper) == false)
        #expect(lhsWrapper.isGreaterThanOrEqual(to: rhsWrapper) == false)
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
        isLess: Bool,
        isLessThanOrEqual: Bool,
        isGreater: Bool,
        isGreaterThanOrEqual: Bool
    ) {
        let lhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: lhs)
        let rhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: rhs)

        #expect((lhsWrapper < rhsWrapper) == isLess)
        #expect((lhsWrapper <= rhsWrapper) == isLessThanOrEqual)
        #expect((lhsWrapper > rhsWrapper) == isGreater)
        #expect((lhsWrapper >= rhsWrapper) == isGreaterThanOrEqual)
        #expect(lhsWrapper.isLess(than: rhsWrapper) == isLess)
        #expect(lhsWrapper.isLessThanOrEqual(to: rhsWrapper) == isLessThanOrEqual)
        #expect(lhsWrapper.isGreater(than: rhsWrapper) == isGreater)
        #expect(lhsWrapper.isGreaterThanOrEqual(to: rhsWrapper) == isGreaterThanOrEqual)
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
        isLess: Bool,
        isLessThanOrEqual: Bool,
        isGreater: Bool,
        isGreaterThanOrEqual: Bool
    ) {
        let lhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: lhs)
        let rhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: rhs)

        #expect((lhsWrapper < rhsWrapper) == isLess)
        #expect((lhsWrapper <= rhsWrapper) == isLessThanOrEqual)
        #expect((lhsWrapper > rhsWrapper) == isGreater)
        #expect((lhsWrapper >= rhsWrapper) == isGreaterThanOrEqual)
        #expect(lhsWrapper.isLess(than: rhsWrapper) == isLess)
        #expect(lhsWrapper.isLessThanOrEqual(to: rhsWrapper) == isLessThanOrEqual)
        #expect(lhsWrapper.isGreater(than: rhsWrapper) == isGreater)
        #expect(lhsWrapper.isGreaterThanOrEqual(to: rhsWrapper) == isGreaterThanOrEqual)
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
        isLess: Bool,
        isLessThanOrEqual: Bool,
        isGreater: Bool,
        isGreaterThanOrEqual: Bool
    ) {
        let lhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: lhs)
        let rhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: rhs)

        #expect((lhsWrapper < rhsWrapper) == isLess)
        #expect((lhsWrapper <= rhsWrapper) == isLessThanOrEqual)
        #expect((lhsWrapper > rhsWrapper) == isGreater)
        #expect((lhsWrapper >= rhsWrapper) == isGreaterThanOrEqual)
        #expect(lhsWrapper.isLess(than: rhsWrapper) == isLess)
        #expect(lhsWrapper.isLessThanOrEqual(to: rhsWrapper) == isLessThanOrEqual)
        #expect(lhsWrapper.isGreater(than: rhsWrapper) == isGreater)
        #expect(lhsWrapper.isGreaterThanOrEqual(to: rhsWrapper) == isGreaterThanOrEqual)
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
        isLess: Bool,
        isLessThanOrEqual: Bool,
        isGreater: Bool,
        isGreaterThanOrEqual: Bool
    ) {
        let lhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: lhs)
        let rhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: rhs)

        #expect((lhsWrapper < rhsWrapper) == isLess)
        #expect((lhsWrapper <= rhsWrapper) == isLessThanOrEqual)
        #expect((lhsWrapper > rhsWrapper) == isGreater)
        #expect((lhsWrapper >= rhsWrapper) == isGreaterThanOrEqual)
        #expect(lhsWrapper.isLess(than: rhsWrapper) == isLess)
        #expect(lhsWrapper.isLessThanOrEqual(to: rhsWrapper) == isLessThanOrEqual)
        #expect(lhsWrapper.isGreater(than: rhsWrapper) == isGreater)
        #expect(lhsWrapper.isGreaterThanOrEqual(to: rhsWrapper) == isGreaterThanOrEqual)
    }
}
