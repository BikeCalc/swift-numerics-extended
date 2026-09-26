// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Canonicalized Fraction Tests")
internal struct CanonicalizedFractionTests {
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
        "Initialization canonicalizes values",
        arguments: Self.canonicalizationArguments
    )
    internal func initializationCanonicalizesValues(
        value: Fraction<Int>,
        result: Fraction<Int>
    ) {
        @Canonicalized
        var canonicalizedValue: Fraction<Int> = value

        #expect(canonicalizedValue == result)
    }

    @Test(
        "Assignment canonicalizes values",
        arguments: Self.canonicalizationArguments
    )
    internal func assignmentCanonicalizesValues(
        value: Fraction<Int>,
        result: Fraction<Int>
    ) {
        @Canonicalized
        var canonicalizedValue: Fraction<Int> = .zero

        canonicalizedValue = value

        #expect(canonicalizedValue == result)
    }
}

// MARK: - NaN

extension CanonicalizedFractionTests {
    @Test("NaN is preserved")
    internal func nanIsPreserved() {
        @Canonicalized
        var value: Fraction<Int> = .nan

        #expect(value.isNaN == true)
    }
}

// MARK: - Negative Infinity

extension CanonicalizedFractionTests {
    @Test("Negative infinity is preserved")
    internal func negativeInfinityIsPreserved() {
        @Canonicalized
        var value: Fraction<Int> = .negativeInfinity

        #expect(value == .negativeInfinity)
    }
}

// MARK: - Negative Zero

extension CanonicalizedFractionTests {
    @Test(
        "Negative zero canonicalization follows rational rules",
        arguments: [
            Fraction<Int>.negativeZero,
            Fraction<Int>(0, -2)
        ]
    )
    internal func negativeZeroCanonicalizationFollowsRationalRules(value: Fraction<Int>) {
        @Canonicalized
        var initializedValue: Fraction<Int> = value

        @Canonicalized
        var assignedValue: Fraction<Int> = .init(1, 2)

        assignedValue = value

        #expect(initializedValue == .zero)
        #expect(assignedValue == .zero)
    }
}

// MARK: - Positive Infinity

extension CanonicalizedFractionTests {
    @Test("Positive infinity is preserved")
    internal func positiveInfinityIsPreserved() {
        @Canonicalized
        var value: Fraction<Int> = .infinity

        #expect(value == .infinity)
    }
}

// MARK: - Positive Zero

extension CanonicalizedFractionTests {
    @Test(
        "Positive zero canonicalization follows rational rules",
        arguments: [
            Fraction<Int>.zero,
            Fraction<Int>(0, 2)
        ]
    )
    internal func positiveZeroCanonicalizationFollowsRationalRules(value: Fraction<Int>) {
        @Canonicalized
        var initializedValue: Fraction<Int> = value

        @Canonicalized
        var assignedValue: Fraction<Int> = .init(1, 2)

        assignedValue = value

        #expect(initializedValue == .zero)
        #expect(assignedValue == .zero)
    }
}
