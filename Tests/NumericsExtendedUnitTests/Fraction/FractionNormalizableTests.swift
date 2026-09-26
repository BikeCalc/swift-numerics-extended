// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Fraction Normalizable Tests")
internal struct FractionNormalizableTests {
    private static let normalizationArguments: [(Fraction<Int>, Fraction<Int>)] = [
        (Fraction<Int>(2, 4), Fraction<Int>(2, 4)),
        (Fraction<Int>(-2, 4), Fraction<Int>(-2, 4)),
        (Fraction<Int>(2, -4), Fraction<Int>(-2, 4)),
        (Fraction<Int>(-2, -4), Fraction<Int>(2, 4)),
        (Fraction<Int>(1, 2), Fraction<Int>(1, 2)),
        (Fraction<Int>(-1, 2), Fraction<Int>(-1, 2)),
        (Fraction<Int>(1, -2), Fraction<Int>(-1, 2)),
        (Fraction<Int>(-1, -2), Fraction<Int>(1, 2))
    ]

    @Test(
        "Is normalizable",
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
    internal func isNormalizable(
        value: Fraction<Int>,
        result: Bool
    ) {
        #expect(value.isNormalizable == result)
    }

    @Test(
        "Is normalized",
        arguments: [
            (Fraction<Int>(2, 4), true),
            (Fraction<Int>(-2, 4), true),
            (Fraction<Int>(2, -4), false),
            (Fraction<Int>(-2, -4), false),
            (Fraction<Int>(1, 2), true),
            (Fraction<Int>(-1, 2), true),
            (Fraction<Int>(1, -2), false),
            (Fraction<Int>(-1, -2), false)
        ]
    )
    internal func isNormalized(
        value: Fraction<Int>,
        result: Bool
    ) {
        #expect(value.isNormalized == result)
    }

    @Test(
        "Normalization succeeds",
        arguments: Self.normalizationArguments
    )
    internal func normalizationSucceeds(
        value: Fraction<Int>,
        result: Fraction<Int>
    ) {
        #expect(value.normalized() == result)
    }

    @Test(
        "Normalize succeeds",
        arguments: Self.normalizationArguments
    )
    internal func normalizeSucceeds(
        value: Fraction<Int>,
        result: Fraction<Int>
    ) {
        var runningValue: Fraction<Int> = value
        runningValue.normalize()
        #expect(runningValue == result)
    }

    @Test(
        "Normalization is idempotent",
        arguments: [
            Fraction<Int>(1, 2),
            Fraction<Int>(2, 4),
            Fraction<Int>(1, -2),
            Fraction<Int>(2, -4)
        ]
    )
    internal func normalizationIsIdempotent(value: Fraction<Int>) {
        let result: Fraction<Int> = value.normalized().normalized()

        #expect(result == value.normalized())
    }
}

// MARK: - IntMin

extension FractionNormalizableTests {
    @Test(
        "Int minimum terms determine normalizability",
        arguments: [
            (Fraction<Int>(Int.min, 2), true),
            (Fraction<Int>(Int.min, -2), false),
            (Fraction<Int>(1, Int.min), false),
            (Fraction<Int>(2, Int.min), false)
        ]
    )
    internal func intMinimumTermsDetermineNormalizability(
        value: Fraction<Int>,
        result: Bool
    ) {
        #expect(value.isNormalizable == result)
    }
}

// MARK: - NaN

extension FractionNormalizableTests {
    @Test("NaN normalization follows rational rules")
    internal func nanNormalizationFollowsRationalRules() {
        #expect(Fraction<Int>.nan.isNormalizable == true)
        #expect(Fraction<Int>.nan.isNormalized == true)
        #expect(Fraction<Int>.nan.normalized().isNaN == true)
    }
}

// MARK: - Negative Infinity

extension FractionNormalizableTests {
    @Test("Negative infinity normalization follows rational rules")
    internal func negativeInfinityNormalizationFollowsRationalRules() {
        #expect(Fraction<Int>.negativeInfinity.isNormalizable == true)
        #expect(Fraction<Int>.negativeInfinity.isNormalized == true)
        #expect(Fraction<Int>.negativeInfinity.normalized() == .negativeInfinity)
    }
}

// MARK: - Negative Zero

extension FractionNormalizableTests {
    @Test(
        "Negative zero normalization follows rational rules",
        arguments: [
            (Fraction<Int>.negativeZero, Fraction<Int>.zero),
            (Fraction<Int>(0, -2), Fraction<Int>(0, 2))
        ]
    )
    internal func negativeZeroNormalizationFollowsRationalRules(
        value: Fraction<Int>,
        result: Fraction<Int>
    ) {
        #expect(value.isNormalizable == true)
        #expect(value.isNormalized == false)
        #expect(value.normalized() == result)
    }
}

// MARK: - Positive Infinity

extension FractionNormalizableTests {
    @Test("Positive infinity normalization follows rational rules")
    internal func positiveInfinityNormalizationFollowsRationalRules() {
        #expect(Fraction<Int>.infinity.isNormalizable == true)
        #expect(Fraction<Int>.infinity.isNormalized == true)
        #expect(Fraction<Int>.infinity.normalized() == .infinity)
    }
}

// MARK: - Positive Zero

extension FractionNormalizableTests {
    @Test(
        "Positive zero normalization follows rational rules",
        arguments: [
            Fraction<Int>.zero,
            Fraction<Int>(0, 2)
        ]
    )
    internal func positiveZeroNormalizationFollowsRationalRules(value: Fraction<Int>) {
        #expect(value.isNormalizable == true)
        #expect(value.isNormalized == true)
        #expect(value.normalized() == value)
    }
}
