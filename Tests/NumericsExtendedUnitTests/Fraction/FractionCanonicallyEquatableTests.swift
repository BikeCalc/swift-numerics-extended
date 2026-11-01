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
    internal init() {}

    @Test(
        "Canonical equality",
        arguments: [
            (.init(1, 2), .init(1, 2), true),
            (.init(1, 2), .init(2, 4), true),
            (.init(-1, 2), .init(-2, 4), true),
            (.init(-1, 2), .init(1, -2), true)
        ] as Array<(Fraction<Int>, Fraction<Int>, Bool)>
    )
    internal func canonicalEquality(
        lhs: Fraction<Int>,
        rhs: Fraction<Int>,
        expected: Bool
    ) {
        let result: Bool = lhs.isCanonicallyEqual(to: rhs)
        #expect(result == expected)
    }
}

// MARK: - IntMin

extension FractionCanonicallyEquatableTests {
    @Test("Canonical equality handles an Int minimum denominator")
    internal func canonicalEqualityHandlesIntMinimumDenominator() {
        let value: Fraction<Int> = .init(1, Int.min)
        let result: Bool = value.isCanonicallyEqual(to: value)
        #expect(result == true)
    }
}

// MARK: - NaN

extension FractionCanonicallyEquatableTests {
    @Test(
        "NaN canonical equality follows rational rules",
        arguments: [
            (.nan, .nan, false),
            (.nan, .init(1, 1), false),
            (.init(1, 1), .nan, false)
        ] as Array<(Fraction<Int>, Fraction<Int>, Bool)>
    )
    internal func nanCanonicalEqualityFollowsRationalRules(
        lhs: Fraction<Int>,
        rhs: Fraction<Int>,
        expected: Bool
    ) {
        let result: Bool = lhs.isCanonicallyEqual(to: rhs)
        #expect(result == expected)
    }
}

// MARK: - Negative Infinity

extension FractionCanonicallyEquatableTests {
    @Test(
        "Negative infinity canonical equality follows rational rules",
        arguments: [
            (.negativeInfinity, .negativeInfinity, true),
            (.negativeInfinity, .infinity, false)
        ] as Array<(Fraction<Int>, Fraction<Int>, Bool)>
    )
    internal func negativeInfinityCanonicalEqualityFollowsRationalRules(
        lhs: Fraction<Int>,
        rhs: Fraction<Int>,
        expected: Bool
    ) {
        let result: Bool = lhs.isCanonicallyEqual(to: rhs)
        #expect(result == expected)
    }
}

// MARK: - Negative Zero

extension FractionCanonicallyEquatableTests {
    @Test(
        "Negative zero canonical equality follows rational rules",
        arguments: [
            (.negativeZero, .negativeZero, true),
            (.negativeZero, .zero, true),
            (.negativeZero, .init(0, -2), true),
            (.negativeZero, .init(-1, 1), false)
        ] as Array<(Fraction<Int>, Fraction<Int>, Bool)>
    )
    internal func negativeZeroCanonicalEqualityFollowsRationalRules(
        lhs: Fraction<Int>,
        rhs: Fraction<Int>,
        expected: Bool
    ) {
        let result: Bool = lhs.isCanonicallyEqual(to: rhs)
        #expect(result == expected)
    }
}

// MARK: - Positive Infinity

extension FractionCanonicallyEquatableTests {
    @Test(
        "Positive infinity canonical equality follows rational rules",
        arguments: [
            (.infinity, .infinity, true),
            (.infinity, .negativeInfinity, false)
        ] as Array<(Fraction<Int>, Fraction<Int>, Bool)>
    )
    internal func positiveInfinityCanonicalEqualityFollowsRationalRules(
        lhs: Fraction<Int>,
        rhs: Fraction<Int>,
        expected: Bool
    ) {
        let result: Bool = lhs.isCanonicallyEqual(to: rhs)
        #expect(result == expected)
    }
}

// MARK: - Positive Zero

extension FractionCanonicallyEquatableTests {
    @Test(
        "Positive zero canonical equality follows rational rules",
        arguments: [
            (.zero, .zero, true),
            (.zero, .negativeZero, true),
            (.zero, .init(0, 2), true),
            (.zero, .init(1, 1), false)
        ] as Array<(Fraction<Int>, Fraction<Int>, Bool)>
    )
    internal func positiveZeroCanonicalEqualityFollowsRationalRules(
        lhs: Fraction<Int>,
        rhs: Fraction<Int>,
        expected: Bool
    ) {
        let result: Bool = lhs.isCanonicallyEqual(to: rhs)
        #expect(result == expected)
    }
}
