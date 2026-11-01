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
    internal init() {}

    private static let normalizationArguments: [(Fraction<Int>, Fraction<Int>)] = [
        (.init(2, 4), .init(2, 4)),
        (.init(-2, 4), .init(-2, 4)),
        (.init(2, -4), .init(-2, 4)),
        (.init(-2, -4), .init(2, 4)),
        (.init(1, 2), .init(1, 2)),
        (.init(-1, 2), .init(-1, 2)),
        (.init(1, -2), .init(-1, 2)),
        (.init(-1, -2), .init(1, 2))
    ]

    @Test(
        "Is normalizable",
        arguments: [
            (.init(2, 4), true),
            (.init(-2, 4), true),
            (.init(2, -4), true),
            (.init(-2, -4), true),
            (.init(1, 2), true),
            (.init(-1, 2), true),
            (.init(1, -2), true),
            (.init(-1, -2), true)
        ] as Array<(Fraction<Int>, Bool)>
    )
    internal func isNormalizable(
        value: Fraction<Int>,
        expected: Bool
    ) {
        #expect(value.isNormalizable == expected)
    }

    @Test(
        "Is normalized",
        arguments: [
            (.init(2, 4), true),
            (.init(-2, 4), true),
            (.init(2, -4), false),
            (.init(-2, -4), false),
            (.init(1, 2), true),
            (.init(-1, 2), true),
            (.init(1, -2), false),
            (.init(-1, -2), false)
        ] as Array<(Fraction<Int>, Bool)>
    )
    internal func isNormalized(
        value: Fraction<Int>,
        expected: Bool
    ) {
        #expect(value.isNormalized == expected)
    }

    @Test(
        "Normalization succeeds",
        arguments: Self.normalizationArguments
    )
    internal func normalizationSucceeds(
        value: Fraction<Int>,
        expected: Fraction<Int>
    ) {
        let result: Fraction<Int> = value.normalized()
        #expect(result == expected)
    }

    @Test(
        "Normalize succeeds",
        arguments: Self.normalizationArguments
    )
    internal func normalizeSucceeds(
        value: Fraction<Int>,
        expected: Fraction<Int>
    ) {
        var result: Fraction<Int> = value
        result.normalize()
        #expect(result == expected)
    }

    @Test(
        "Normalization is idempotent",
        arguments: [
            .init(1, 2),
            .init(2, 4),
            .init(1, -2),
            .init(2, -4)
        ] as Array<Fraction<Int>>
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
            (.init(Int.min, 2), true),
            (.init(Int.min, -2), false),
            (.init(1, Int.min), false),
            (.init(2, Int.min), false)
        ] as Array<(Fraction<Int>, Bool)>
    )
    internal func intMinimumTermsDetermineNormalizability(
        value: Fraction<Int>,
        expected: Bool
    ) {
        #expect(value.isNormalizable == expected)
    }
}

// MARK: - NaN

extension FractionNormalizableTests {
    @Test("NaN normalization follows rational rules")
    internal func nanNormalizationFollowsRationalRules() {
        #expect(Fraction<Int>.nan.isNormalizable == true)
        #expect(Fraction<Int>.nan.isNormalized == true)
        let result: Fraction<Int> = Fraction<Int>.nan.normalized()
        #expect(result.isNaN == true)
    }
}

// MARK: - Negative Infinity

extension FractionNormalizableTests {
    @Test("Negative infinity normalization follows rational rules")
    internal func negativeInfinityNormalizationFollowsRationalRules() {
        #expect(Fraction<Int>.negativeInfinity.isNormalizable == true)
        #expect(Fraction<Int>.negativeInfinity.isNormalized == true)
        let result: Fraction<Int> = Fraction<Int>.negativeInfinity.normalized()
        #expect(result == .negativeInfinity)
    }
}

// MARK: - Negative Zero

extension FractionNormalizableTests {
    @Test(
        "Negative zero normalization follows rational rules",
        arguments: [
            (.negativeZero, .zero),
            (.init(0, -2), .init(0, 2))
        ] as Array<(Fraction<Int>, Fraction<Int>)>
    )
    internal func negativeZeroNormalizationFollowsRationalRules(
        value: Fraction<Int>,
        expected: Fraction<Int>
    ) {
        #expect(value.isNormalizable == true)
        #expect(value.isNormalized == false)
        let result: Fraction<Int> = value.normalized()
        #expect(result == expected)
    }
}

// MARK: - Positive Infinity

extension FractionNormalizableTests {
    @Test("Positive infinity normalization follows rational rules")
    internal func positiveInfinityNormalizationFollowsRationalRules() {
        #expect(Fraction<Int>.infinity.isNormalizable == true)
        #expect(Fraction<Int>.infinity.isNormalized == true)
        let result: Fraction<Int> = Fraction<Int>.infinity.normalized()
        #expect(result == .infinity)
    }
}

// MARK: - Positive Zero

extension FractionNormalizableTests {
    @Test(
        "Positive zero normalization follows rational rules",
        arguments: [
            .zero,
            .init(0, 2)
        ] as Array<Fraction<Int>>
    )
    internal func positiveZeroNormalizationFollowsRationalRules(value: Fraction<Int>) {
        #expect(value.isNormalizable == true)
        #expect(value.isNormalized == true)
        let result: Fraction<Int> = value.normalized()
        #expect(result == value)
    }
}
