// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Fraction Equatable Tests")
internal struct FractionEquatableTests {
    private static let equalityArguments: [(Fraction<Int>, Fraction<Int>, Bool)] = [
        (Fraction<Int>(1, 2), Fraction<Int>(1, 2), true),
        (Fraction<Int>(1, 2), Fraction<Int>(2, 3), false),
        (Fraction<Int>(1, 2), Fraction<Int>(2, 4), false),
        (Fraction<Int>(-1, 2), Fraction<Int>(-1, 2), true),
        (Fraction<Int>(-1, 2), Fraction<Int>(-2, 3), false),
        (Fraction<Int>(-1, 2), Fraction<Int>(1, -2), false)
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
        #expect((lhs == rhs) == result)
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
        #expect((lhs != rhs) == !result)
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
        #expect(lhs.isEqual(to: rhs) == result)
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
        #expect(lhs.isUnequal(to: rhs) == !result)
    }
}

// MARK: - NaN

extension FractionEquatableTests {
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
        #expect((lhs == rhs) == result)
        #expect((lhs != rhs) == !result)
        #expect(lhs.isEqual(to: rhs) == result)
        #expect(lhs.isUnequal(to: rhs) == !result)
    }
}

// MARK: - Negative Infinity

extension FractionEquatableTests {
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
        #expect((lhs == rhs) == result)
        #expect((lhs != rhs) == !result)
        #expect(lhs.isEqual(to: rhs) == result)
        #expect(lhs.isUnequal(to: rhs) == !result)
    }
}

// MARK: - Negative Zero

extension FractionEquatableTests {
    @Test(
        "Negative zero equality follows stored representation rules",
        arguments: [
            (Fraction<Int>.negativeZero, Fraction<Int>.negativeZero, true),
            (Fraction<Int>.negativeZero, Fraction<Int>.zero, false),
            (Fraction<Int>.negativeZero, Fraction<Int>(-1, 1), false)
        ]
    )
    internal func negativeZeroEqualityFollowsStoredRepresentationRules(
        lhs: Fraction<Int>,
        rhs: Fraction<Int>,
        result: Bool
    ) {
        #expect((lhs == rhs) == result)
        #expect((lhs != rhs) == !result)
        #expect(lhs.isEqual(to: rhs) == result)
        #expect(lhs.isUnequal(to: rhs) == !result)
    }
}

// MARK: - Positive Infinity

extension FractionEquatableTests {
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
        #expect((lhs == rhs) == result)
        #expect((lhs != rhs) == !result)
        #expect(lhs.isEqual(to: rhs) == result)
        #expect(lhs.isUnequal(to: rhs) == !result)
    }
}

// MARK: - Positive Zero

extension FractionEquatableTests {
    @Test(
        "Positive zero equality follows stored representation rules",
        arguments: [
            (Fraction<Int>.zero, Fraction<Int>.zero, true),
            (Fraction<Int>.zero, Fraction<Int>.negativeZero, false),
            (Fraction<Int>.zero, Fraction<Int>(1, 1), false)
        ]
    )
    internal func positiveZeroEqualityFollowsStoredRepresentationRules(
        lhs: Fraction<Int>,
        rhs: Fraction<Int>,
        result: Bool
    ) {
        #expect((lhs == rhs) == result)
        #expect((lhs != rhs) == !result)
        #expect(lhs.isEqual(to: rhs) == result)
        #expect(lhs.isUnequal(to: rhs) == !result)
    }
}
