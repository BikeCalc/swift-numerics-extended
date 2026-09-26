// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Fraction CanonicallyEquatable Tests")
internal struct FractionCanonicallyEquatableTests {
    @Test(
        "Canonical equality",
        arguments: [
            (Fraction<Int>(1, 2), Fraction<Int>(1, 2), true),
            (Fraction<Int>(1, 2), Fraction<Int>(2, 4), true),
            (Fraction<Int>(-1, 2), Fraction<Int>(-2, 4), true),
            (Fraction<Int>(-1, 2), Fraction<Int>(1, -2), true)
        ]
    )
    internal func canonicalEquality(
        lhs: Fraction<Int>,
        rhs: Fraction<Int>,
        result: Bool
    ) {
        #expect(lhs.isCanonicallyEquatable(to: rhs) == result)
    }
}

// MARK: - IntMin

extension FractionCanonicallyEquatableTests {
    @Test("Canonical equality handles an Int minimum denominator")
    internal func canonicalEqualityHandlesIntMinimumDenominator() {
        let value: Fraction<Int> = .init(1, Int.min)

        #expect(value.isCanonicallyEquatable(to: value) == true)
    }
}

// MARK: - NaN

extension FractionCanonicallyEquatableTests {
    @Test(
        "NaN canonical equality follows rational rules",
        arguments: [
            (Fraction<Int>.nan, Fraction<Int>.nan, false),
            (Fraction<Int>.nan, Fraction<Int>(1, 1), false),
            (Fraction<Int>(1, 1), Fraction<Int>.nan, false)
        ]
    )
    internal func nanCanonicalEqualityFollowsRationalRules(
        lhs: Fraction<Int>,
        rhs: Fraction<Int>,
        result: Bool
    ) {
        #expect(lhs.isCanonicallyEquatable(to: rhs) == result)
    }
}

// MARK: - Negative Infinity

extension FractionCanonicallyEquatableTests {
    @Test(
        "Negative infinity canonical equality follows rational rules",
        arguments: [
            (Fraction<Int>.negativeInfinity, Fraction<Int>.negativeInfinity, true),
            (Fraction<Int>.negativeInfinity, Fraction<Int>.infinity, false)
        ]
    )
    internal func negativeInfinityCanonicalEqualityFollowsRationalRules(
        lhs: Fraction<Int>,
        rhs: Fraction<Int>,
        result: Bool
    ) {
        #expect(lhs.isCanonicallyEquatable(to: rhs) == result)
    }
}

// MARK: - Negative Zero

extension FractionCanonicallyEquatableTests {
    @Test(
        "Negative zero canonical equality follows rational rules",
        arguments: [
            (Fraction<Int>.negativeZero, Fraction<Int>.negativeZero, true),
            (Fraction<Int>.negativeZero, Fraction<Int>.zero, true),
            (Fraction<Int>.negativeZero, Fraction<Int>(0, -2), true),
            (Fraction<Int>.negativeZero, Fraction<Int>(-1, 1), false)
        ]
    )
    internal func negativeZeroCanonicalEqualityFollowsRationalRules(
        lhs: Fraction<Int>,
        rhs: Fraction<Int>,
        result: Bool
    ) {
        #expect(lhs.isCanonicallyEquatable(to: rhs) == result)
    }
}

// MARK: - Positive Infinity

extension FractionCanonicallyEquatableTests {
    @Test(
        "Positive infinity canonical equality follows rational rules",
        arguments: [
            (Fraction<Int>.infinity, Fraction<Int>.infinity, true),
            (Fraction<Int>.infinity, Fraction<Int>.negativeInfinity, false)
        ]
    )
    internal func positiveInfinityCanonicalEqualityFollowsRationalRules(
        lhs: Fraction<Int>,
        rhs: Fraction<Int>,
        result: Bool
    ) {
        #expect(lhs.isCanonicallyEquatable(to: rhs) == result)
    }
}

// MARK: - Positive Zero

extension FractionCanonicallyEquatableTests {
    @Test(
        "Positive zero canonical equality follows rational rules",
        arguments: [
            (Fraction<Int>.zero, Fraction<Int>.zero, true),
            (Fraction<Int>.zero, Fraction<Int>.negativeZero, true),
            (Fraction<Int>.zero, Fraction<Int>(0, 2), true),
            (Fraction<Int>.zero, Fraction<Int>(1, 1), false)
        ]
    )
    internal func positiveZeroCanonicalEqualityFollowsRationalRules(
        lhs: Fraction<Int>,
        rhs: Fraction<Int>,
        result: Bool
    ) {
        #expect(lhs.isCanonicallyEquatable(to: rhs) == result)
    }
}
