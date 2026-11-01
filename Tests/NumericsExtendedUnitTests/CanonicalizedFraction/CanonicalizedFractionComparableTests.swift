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
        (.init(1, 2), .init(1, 2), false, true, false, true),
        (.init(1, 2), .init(2, 4), false, true, false, true),
        (.init(2, 2), .init(3, 2), true, true, false, false),
        (.init(3, 2), .init(2, 2), false, false, true, true),
        (.init(-2, 2), .init(3, 2), true, true, false, false),
        (.init(-3, 2), .init(-2, 2), true, true, false, false)
    ]

    private static let rangeArguments: [(Fraction<Int>, Fraction<Int>, Fraction<Int>)] = [
        (.init(1, 2), .init(2, 2), .init(4, 2)),
        (.init(2, 2), .init(2, 2), .init(4, 2)),
        (.init(3, 2), .init(2, 2), .init(4, 2)),
        (.init(4, 2), .init(2, 2), .init(4, 2)),
        (.init(5, 2), .init(2, 2), .init(4, 2)),
        (.init(-5, 2), .init(-4, 2), .init(-2, 2)),
        (.init(-4, 2), .init(-4, 2), .init(-2, 2)),
        (.init(-3, 2), .init(-4, 2), .init(-2, 2)),
        (.init(-2, 2), .init(-4, 2), .init(-2, 2)),
        (.init(-1, 2), .init(-4, 2), .init(-2, 2))
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
            (.nan, .init(1, 1)),
            (.init(1, 1), .nan),
            (.nan, .nan)
        ] as Array<(Fraction<Int>, Fraction<Int>)>
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
            (.negativeInfinity, .negativeInfinity, false, true, false, true),
            (.negativeInfinity, .init(-1, 1), true, true, false, false),
            (.negativeInfinity, .infinity, true, true, false, false)
        ] as Array<(Fraction<Int>, Fraction<Int>, Bool, Bool, Bool, Bool)>
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
            (.negativeZero, .negativeZero, false, true, false, true),
            (.negativeZero, .zero, false, true, false, true),
            (.negativeZero, .init(1, 1), true, true, false, false),
            (.negativeZero, .init(-1, 1), false, false, true, true)
        ] as Array<(Fraction<Int>, Fraction<Int>, Bool, Bool, Bool, Bool)>
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
            (.infinity, .infinity, false, true, false, true),
            (.infinity, .init(1, 1), false, false, true, true),
            (.infinity, .negativeInfinity, false, false, true, true)
        ] as Array<(Fraction<Int>, Fraction<Int>, Bool, Bool, Bool, Bool)>
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
            (.zero, .zero, false, true, false, true),
            (.zero, .negativeZero, false, true, false, true),
            (.zero, .init(1, 1), true, true, false, false),
            (.zero, .init(-1, 1), false, false, true, true)
        ] as Array<(Fraction<Int>, Fraction<Int>, Bool, Bool, Bool, Bool)>
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
