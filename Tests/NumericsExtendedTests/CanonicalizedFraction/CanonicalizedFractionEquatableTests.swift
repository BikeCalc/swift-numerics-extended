// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Canonicalized Fraction Equatable Tests")
internal struct CanonicalizedFractionEquatableTests {
    private static let equalityArguments: [(Fraction<Int>, Fraction<Int>, Bool)] = [
        (Fraction<Int>(1, 2), Fraction<Int>(1, 2), true),
        (Fraction<Int>(1, 2), Fraction<Int>(2, 3), false),
        (Fraction<Int>(1, 2), Fraction<Int>(2, 4), true),
        (Fraction<Int>(-1, 2), Fraction<Int>(-1, 2), true),
        (Fraction<Int>(-1, 2), Fraction<Int>(-2, 3), false),
        (Fraction<Int>(-1, 2), Fraction<Int>(1, -2), true)
    ]

    @Test(
        "Equality succeeds",
        arguments: Self.equalityArguments
    )
    internal func equalitySucceeds(
        lhs: Fraction<Int>,
        rhs: Fraction<Int>,
        result: Bool
    ) {
        let lhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: lhs)
        let rhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: rhs)

        #expect((lhsWrapper == rhsWrapper) == result)
    }

    @Test(
        "Inequality succeeds",
        arguments: Self.equalityArguments
    )
    internal func inequalitySucceeds(
        lhs: Fraction<Int>,
        rhs: Fraction<Int>,
        result: Bool
    ) {
        let lhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: lhs)
        let rhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: rhs)

        #expect((lhsWrapper != rhsWrapper) == !result)
    }

    @Test(
        "Is equal succeeds",
        arguments: Self.equalityArguments
    )
    internal func isEqualSucceeds(
        lhs: Fraction<Int>,
        rhs: Fraction<Int>,
        result: Bool
    ) {
        let lhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: lhs)
        let rhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: rhs)

        #expect(lhsWrapper.isEqual(to: rhsWrapper) == result)
    }

    @Test(
        "Is unequal succeeds",
        arguments: Self.equalityArguments
    )
    internal func isUnequalSucceeds(
        lhs: Fraction<Int>,
        rhs: Fraction<Int>,
        result: Bool
    ) {
        let lhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: lhs)
        let rhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: rhs)

        #expect(lhsWrapper.isUnequal(to: rhsWrapper) == !result)
    }
}

// MARK: - NaN

extension CanonicalizedFractionEquatableTests {
    @Test(
        "NaN equality follows rational rules",
        arguments: [
            (Fraction<Int>.nan, Fraction<Int>.nan, false),
            (Fraction<Int>.nan, Fraction<Int>(1, 1), false),
            (Fraction<Int>(1, 1), Fraction<Int>.nan, false)
        ]
    )
    internal func nanEqualityFollowsRationalRules(
        lhs: Fraction<Int>,
        rhs: Fraction<Int>,
        result: Bool
    ) {
        let lhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: lhs)
        let rhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: rhs)

        #expect((lhsWrapper == rhsWrapper) == result)
        #expect((lhsWrapper != rhsWrapper) == !result)
        #expect(lhsWrapper.isEqual(to: rhsWrapper) == result)
        #expect(lhsWrapper.isUnequal(to: rhsWrapper) == !result)
    }
}

// MARK: - Negative Infinity

extension CanonicalizedFractionEquatableTests {
    @Test(
        "Negative infinity equality follows rational rules",
        arguments: [
            (Fraction<Int>.negativeInfinity, Fraction<Int>.negativeInfinity, true),
            (Fraction<Int>.negativeInfinity, Fraction<Int>.infinity, false)
        ]
    )
    internal func negativeInfinityEqualityFollowsRationalRules(
        lhs: Fraction<Int>,
        rhs: Fraction<Int>,
        result: Bool
    ) {
        let lhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: lhs)
        let rhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: rhs)

        #expect((lhsWrapper == rhsWrapper) == result)
        #expect((lhsWrapper != rhsWrapper) == !result)
        #expect(lhsWrapper.isEqual(to: rhsWrapper) == result)
        #expect(lhsWrapper.isUnequal(to: rhsWrapper) == !result)
    }
}

// MARK: - Negative Zero

extension CanonicalizedFractionEquatableTests {
    @Test(
        "Negative zero equality follows rational rules",
        arguments: [
            (Fraction<Int>.negativeZero, Fraction<Int>.negativeZero, true),
            (Fraction<Int>.negativeZero, Fraction<Int>.zero, true),
            (Fraction<Int>.negativeZero, Fraction<Int>(0, -2), true),
            (Fraction<Int>.negativeZero, Fraction<Int>(-1, 1), false)
        ]
    )
    internal func negativeZeroEqualityFollowsRationalRules(
        lhs: Fraction<Int>,
        rhs: Fraction<Int>,
        result: Bool
    ) {
        let lhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: lhs)
        let rhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: rhs)

        #expect((lhsWrapper == rhsWrapper) == result)
        #expect((lhsWrapper != rhsWrapper) == !result)
        #expect(lhsWrapper.isEqual(to: rhsWrapper) == result)
        #expect(lhsWrapper.isUnequal(to: rhsWrapper) == !result)
    }
}

// MARK: - Positive Infinity

extension CanonicalizedFractionEquatableTests {
    @Test(
        "Positive infinity equality follows rational rules",
        arguments: [
            (Fraction<Int>.infinity, Fraction<Int>.infinity, true),
            (Fraction<Int>.infinity, Fraction<Int>.negativeInfinity, false)
        ]
    )
    internal func positiveInfinityEqualityFollowsRationalRules(
        lhs: Fraction<Int>,
        rhs: Fraction<Int>,
        result: Bool
    ) {
        let lhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: lhs)
        let rhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: rhs)

        #expect((lhsWrapper == rhsWrapper) == result)
        #expect((lhsWrapper != rhsWrapper) == !result)
        #expect(lhsWrapper.isEqual(to: rhsWrapper) == result)
        #expect(lhsWrapper.isUnequal(to: rhsWrapper) == !result)
    }
}

// MARK: - Positive Zero

extension CanonicalizedFractionEquatableTests {
    @Test(
        "Positive zero equality follows rational rules",
        arguments: [
            (Fraction<Int>.zero, Fraction<Int>.zero, true),
            (Fraction<Int>.zero, Fraction<Int>.negativeZero, true),
            (Fraction<Int>.zero, Fraction<Int>(0, 2), true),
            (Fraction<Int>.zero, Fraction<Int>(1, 1), false)
        ]
    )
    internal func positiveZeroEqualityFollowsRationalRules(
        lhs: Fraction<Int>,
        rhs: Fraction<Int>,
        result: Bool
    ) {
        let lhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: lhs)
        let rhsWrapper: Canonicalized<Fraction<Int>> = .init(wrappedValue: rhs)

        #expect((lhsWrapper == rhsWrapper) == result)
        #expect((lhsWrapper != rhsWrapper) == !result)
        #expect(lhsWrapper.isEqual(to: rhsWrapper) == result)
        #expect(lhsWrapper.isUnequal(to: rhsWrapper) == !result)
    }
}
