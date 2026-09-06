// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Canonicalized Fraction Negateable Tests")
internal struct CanonicalizedFractionNegateableTests {
    private static let negationArguments: [(Fraction<Int>, Fraction<Int>)] = [
        (Fraction<Int>(1, 2), Fraction<Int>(-1, 2)),
        (Fraction<Int>(-1, 2), Fraction<Int>(1, 2)),
        (Fraction<Int>(2, 4), Fraction<Int>(-1, 2)),
        (Fraction<Int>(-2, 4), Fraction<Int>(1, 2)),
        (Fraction<Int>(2, -4), Fraction<Int>(1, 2)),
        (Fraction<Int>(-2, -4), Fraction<Int>(-1, 2))
    ]

    @Test(
        "Negate preserves canonical representation",
        arguments: Self.negationArguments
    )
    internal func negatePreservesCanonicalRepresentation(
        value: Fraction<Int>,
        negation: Fraction<Int>
    ) {
        @Canonicalized
        var runningValue: Fraction<Int> = value

        runningValue.negate()

        #expect(runningValue == negation)
        #expect(runningValue.isCanonicalized == true)
    }
}

// MARK: - NaN

extension CanonicalizedFractionNegateableTests {
    @Test("Negating NaN returns NaN")
    internal func negatingNaNReturnsNaN() {
        @Canonicalized
        var value: Fraction<Int> = .nan

        value.negate()

        #expect(value.isNaN == true)
        #expect(value.isCanonicalized == true)
    }
}

// MARK: - Negative Infinity

extension CanonicalizedFractionNegateableTests {
    @Test("Negating negative infinity follows rational rules")
    internal func negatingNegativeInfinityFollowsRationalRules() {
        @Canonicalized
        var value: Fraction<Int> = .negativeInfinity

        value.negate()

        #expect(value == .infinity)
        #expect(value.isCanonicalized == true)
    }
}

// MARK: - Negative Zero

extension CanonicalizedFractionNegateableTests {
    @Test(
        "Negating negative zero preserves canonical representation",
        arguments: [
            Fraction<Int>.negativeZero,
            Fraction<Int>(0, -2)
        ]
    )
    internal func negatingNegativeZeroPreservesCanonicalRepresentation(value: Fraction<Int>) {
        @Canonicalized
        var runningValue: Fraction<Int> = value

        runningValue.negate()

        #expect(runningValue == .zero)
        #expect(runningValue.isCanonicalized == true)
    }
}

// MARK: - Positive Infinity

extension CanonicalizedFractionNegateableTests {
    @Test("Negating positive infinity follows rational rules")
    internal func negatingPositiveInfinityFollowsRationalRules() {
        @Canonicalized
        var value: Fraction<Int> = .infinity

        value.negate()

        #expect(value == .negativeInfinity)
        #expect(value.isCanonicalized == true)
    }
}

// MARK: - Positive Zero

extension CanonicalizedFractionNegateableTests {
    @Test(
        "Negating positive zero preserves canonical representation",
        arguments: [
            Fraction<Int>.zero,
            Fraction<Int>(0, 2)
        ]
    )
    internal func negatingPositiveZeroPreservesCanonicalRepresentation(value: Fraction<Int>) {
        @Canonicalized
        var runningValue: Fraction<Int> = value

        runningValue.negate()

        #expect(runningValue == .zero)
        #expect(runningValue.isCanonicalized == true)
    }
}
