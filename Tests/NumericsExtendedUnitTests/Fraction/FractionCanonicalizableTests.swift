// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Fraction Canonicalizable Tests")
internal struct FractionCanonicalizableTests {
    private static let canonicalizationArguments: [(Fraction<Int>, Fraction<Int>)] = [
        (Fraction<Int>(2, 4), Fraction<Int>(1, 2)),
        (Fraction<Int>(-2, 4), Fraction<Int>(-1, 2)),
        (Fraction<Int>(2, -4), Fraction<Int>(-1, 2)),
        (Fraction<Int>(-2, -4), Fraction<Int>(1, 2)),
        (Fraction<Int>(1, 2), Fraction<Int>(1, 2)),
        (Fraction<Int>(-1, 2), Fraction<Int>(-1, 2)),
        (Fraction<Int>(1, -2), Fraction<Int>(-1, 2)),
        (Fraction<Int>(-1, -2), Fraction<Int>(1, 2))
    ]

    @Test(
        "Is canonicalizable",
        arguments: [
            (Fraction<Int>(2, 4), true),
            (Fraction<Int>(-2, 4), true),
            (Fraction<Int>(2, -4), true),
            (Fraction<Int>(-2, -4), true),
            (Fraction<Int>(1, 2), true),
            (Fraction<Int>(-1, 2), true),
            (Fraction<Int>(1, -2), true),
            (Fraction<Int>(-1, -2), true)
        ]
    )
    internal func isCanonicalizable(
        value: Fraction<Int>,
        result: Bool
    ) {
        #expect(value.isCanonicalizable == result)
    }

    @Test(
        "Is canonicalized",
        arguments: [
            (Fraction<Int>(2, 4), false),
            (Fraction<Int>(-2, 4), false),
            (Fraction<Int>(2, -4), false),
            (Fraction<Int>(-2, -4), false),
            (Fraction<Int>(1, 2), true),
            (Fraction<Int>(-1, 2), true),
            (Fraction<Int>(1, -2), false),
            (Fraction<Int>(-1, -2), false)
        ]
    )
    internal func isCanonicalized(
        value: Fraction<Int>,
        result: Bool
    ) {
        #expect(value.isCanonicalized == result)
    }

    @Test(
        "Canonicalization succeeds",
        arguments: Self.canonicalizationArguments
    )
    internal func canonicalizationSucceeds(
        value: Fraction<Int>,
        result: Fraction<Int>
    ) {
        #expect(value.canonicalized() == result)
    }

    @Test(
        "Canonicalize succeeds",
        arguments: Self.canonicalizationArguments
    )
    internal func canonicalizeSucceeds(
        value: Fraction<Int>,
        result: Fraction<Int>
    ) {
        var runningValue: Fraction<Int> = value
        runningValue.canonicalize()
        #expect(runningValue == result)
    }

    @Test(
        "Canonicalization is idempotent",
        arguments: [
            Fraction<Int>(1, 2),
            Fraction<Int>(2, 4),
            Fraction<Int>(1, -2),
            Fraction<Int>(2, -4)
        ]
    )
    internal func canonicalizationIsIdempotent(value: Fraction<Int>) {
        let result: Fraction<Int> = value.canonicalized().canonicalized()

        #expect(result == value.canonicalized())
    }
}

// MARK: - IntMin

extension FractionCanonicalizableTests {
    @Test("Reducible Int minimum denominator is canonicalizable")
    internal func reducibleIntMinimumDenominatorIsCanonicalizable() {
        let value: Fraction<Int> = .init(2, Int.min)
        let expected: Fraction<Int> = .init(-1, Int.zero - (Int.min / 2))

        #expect(value.isCanonicalizable == true)
        #expect(value.canonicalized() == expected)
    }

    @Test("Irreducible Int minimum denominator is not canonicalizable")
    internal func irreducibleIntMinimumDenominatorIsNotCanonicalizable() {
        let value: Fraction<Int> = .init(1, Int.min)

        #expect(value.isCanonicalizable == false)
        #expect(value.isCanonicalized == false)
    }
}

// MARK: - NaN

extension FractionCanonicalizableTests {
    @Test("NaN canonicalization follows rational rules")
    internal func nanCanonicalizationFollowsRationalRules() {
        #expect(Fraction<Int>.nan.isCanonicalizable == true)
        #expect(Fraction<Int>.nan.isCanonicalized == true)
        #expect(Fraction<Int>.nan.canonicalized().isNaN == true)
    }
}

// MARK: - Negative Infinity

extension FractionCanonicalizableTests {
    @Test("Negative infinity canonicalization follows rational rules")
    internal func negativeInfinityCanonicalizationFollowsRationalRules() {
        #expect(Fraction<Int>.negativeInfinity.isCanonicalizable == true)
        #expect(Fraction<Int>.negativeInfinity.isCanonicalized == true)
        #expect(Fraction<Int>.negativeInfinity.canonicalized() == .negativeInfinity)
    }
}

// MARK: - Negative Zero

extension FractionCanonicalizableTests {
    @Test(
        "Negative zero canonicalization follows rational rules",
        arguments: [
            Fraction<Int>.negativeZero,
            Fraction<Int>(0, -2)
        ]
    )
    internal func negativeZeroCanonicalizationFollowsRationalRules(value: Fraction<Int>) {
        #expect(value.isCanonicalizable == true)
        #expect(value.isCanonicalized == false)
        #expect(value.canonicalized() == .zero)
    }
}

// MARK: - Positive Infinity

extension FractionCanonicalizableTests {
    @Test("Positive infinity canonicalization follows rational rules")
    internal func positiveInfinityCanonicalizationFollowsRationalRules() {
        #expect(Fraction<Int>.infinity.isCanonicalizable == true)
        #expect(Fraction<Int>.infinity.isCanonicalized == true)
        #expect(Fraction<Int>.infinity.canonicalized() == .infinity)
    }
}

// MARK: - Positive Zero

extension FractionCanonicalizableTests {
    @Test(
        "Positive zero canonicalization follows rational rules",
        arguments: [
            (Fraction<Int>.zero, true),
            (Fraction<Int>(0, 2), false)
        ]
    )
    internal func positiveZeroCanonicalizationFollowsRationalRules(
        value: Fraction<Int>,
        isCanonicalized: Bool
    ) {
        #expect(value.isCanonicalizable == true)
        #expect(value.isCanonicalized == isCanonicalized)
        #expect(value.canonicalized() == .zero)
    }
}
