// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Fraction Addable Tests")
internal struct FractionAddableTests {
    private static let additionArguments: [(Fraction<Int>, Fraction<Int>, Fraction<Int>)] = [
        (Fraction<Int>(1, 2), Fraction<Int>(1, 2), Fraction<Int>(2, 2)),
        (Fraction<Int>(1, 2), Fraction<Int>(2, 3), Fraction<Int>(7, 6)),
        (Fraction<Int>(-1, 2), Fraction<Int>(1, 2), Fraction<Int>(0, 2)),
        (Fraction<Int>(-1, 2), Fraction<Int>(-2, 3), Fraction<Int>(-7, 6))
    ]

    @Test(
        "Addition succeeds",
        arguments: Self.additionArguments
    )
    internal func additionSucceeds(
        augend: Fraction<Int>,
        addend: Fraction<Int>,
        sum: Fraction<Int>
    ) {
        #expect(augend + addend == sum)
    }

    @Test(
        "Addition equal succeeds",
        arguments: Self.additionArguments
    )
    internal func additionEqualSucceeds(
        augend: Fraction<Int>,
        addend: Fraction<Int>,
        sum: Fraction<Int>
    ) {
        var runningSum: Fraction<Int> = augend
        runningSum += addend
        #expect(runningSum == sum)
    }

    @Test(
        "Adding succeeds",
        arguments: Self.additionArguments
    )
    internal func addingSucceeds(
        augend: Fraction<Int>,
        addend: Fraction<Int>,
        sum: Fraction<Int>
    ) {
        #expect(augend.adding(addend) == sum)
    }

    @Test(
        "Add succeeds",
        arguments: Self.additionArguments
    )
    internal func addSucceeds(
        augend: Fraction<Int>,
        addend: Fraction<Int>,
        sum: Fraction<Int>
    ) {
        var runningSum: Fraction<Int> = augend
        runningSum.add(addend)
        #expect(runningSum == sum)
    }
}

extension FractionAddableTests {
    @Test(
        "Addition is commutative",
        arguments: Self.additionArguments
    )
    internal func additionIsCommutative(
        augend: Fraction<Int>,
        addend: Fraction<Int>,
        sum _: Fraction<Int>
    ) {
        #expect(augend + addend == addend + augend)
    }
}

// MARK: - NaN

extension FractionAddableTests {
    @Test("Adding positive infinity to negative infinity returns NaN")
    internal func addingPositiveInfinityToNegativeInfinityReturnsNaN() {
        #expect((Fraction<Int>.negativeInfinity + .infinity).isNaN == true)
    }

    @Test("Adding negative infinity to positive infinity returns NaN")
    internal func addingNegativeInfinityToPositiveInfinityReturnsNaN() {
        #expect((Fraction<Int>.infinity + .negativeInfinity).isNaN == true)
    }

    @Test(
        "Adding to NaN returns NaN",
        arguments: [
            Fraction<Int>.nan,
            Fraction<Int>.zero,
            Fraction<Int>.negativeZero,
            Fraction<Int>(1, 1),
            Fraction<Int>.infinity,
            Fraction<Int>.negativeInfinity
        ]
    )
    internal func addingToNaNReturnsNaN(addend: Fraction<Int>) {
        #expect((Fraction<Int>.nan + addend).isNaN == true)
    }

    @Test(
        "Adding NaN returns NaN",
        arguments: [
            Fraction<Int>.zero,
            Fraction<Int>.negativeZero,
            Fraction<Int>(1, 1),
            Fraction<Int>(-1, 1),
            Fraction<Int>.infinity,
            Fraction<Int>.negativeInfinity
        ]
    )
    internal func addingNaNReturnsNaN(augend: Fraction<Int>) {
        #expect((augend + Fraction<Int>.nan).isNaN == true)
    }
}

// MARK: - Negative Infinity

extension FractionAddableTests {
    @Test(
        "Adding to negative infinity follows rational rules",
        arguments: [
            Fraction<Int>.negativeInfinity,
            Fraction<Int>(1, 1),
            Fraction<Int>(-1, 1)
        ]
    )
    internal func addingToNegativeInfinityFollowsRationalRules(addend: Fraction<Int>) {
        #expect(Fraction<Int>.negativeInfinity + addend == .negativeInfinity)
    }
}

// MARK: - Negative Zero

extension FractionAddableTests {
    @Test(
        "Adding to negative zero follows stored representation rules",
        arguments: [
            (Fraction<Int>.zero, Fraction<Int>.negativeZero),
            (Fraction<Int>.negativeZero, Fraction<Int>.negativeZero),
            (Fraction<Int>(1, 1), Fraction<Int>(-1, -1)),
            (Fraction<Int>(-1, 1), Fraction<Int>(1, -1))
        ]
    )
    internal func addingToNegativeZeroFollowsStoredRepresentationRules(
        addend: Fraction<Int>,
        sum: Fraction<Int>
    ) {
        #expect(Fraction<Int>.negativeZero + addend == sum)
    }
}

// MARK: - Positive Infinity

extension FractionAddableTests {
    @Test(
        "Adding to positive infinity follows rational rules",
        arguments: [
            Fraction<Int>.infinity,
            Fraction<Int>(1, 1),
            Fraction<Int>(-1, 1)
        ]
    )
    internal func addingToPositiveInfinityFollowsRationalRules(addend: Fraction<Int>) {
        #expect(Fraction<Int>.infinity + addend == .infinity)
    }
}

// MARK: - Positive Zero

extension FractionAddableTests {
    @Test(
        "Adding opposite values returns positive zero",
        arguments: [
            (Fraction<Int>(1, 2), Fraction<Int>(-1, 2)),
            (Fraction<Int>(2, 3), Fraction<Int>(-2, 3)),
            (Fraction<Int>(-1, 2), Fraction<Int>(1, 2)),
            (Fraction<Int>(-2, 3), Fraction<Int>(2, 3))
        ]
    )
    internal func addingOppositeValuesReturnsPositiveZero(
        augend: Fraction<Int>,
        addend: Fraction<Int>
    ) {
        let sum: Fraction<Int> = augend + addend
        #expect(sum.isZero == true)
        #expect(sum.denominator > 0)
    }

    @Test(
        "Adding positive zero preserves augend",
        arguments: [
            Fraction<Int>(1, 2),
            Fraction<Int>(2, 3),
            Fraction<Int>(-1, 2),
            Fraction<Int>(-2, 3)
        ]
    )
    internal func addingPositiveZeroPreservesAugend(augend: Fraction<Int>) {
        #expect(augend + .zero == augend)
    }

    @Test(
        "Adding to positive zero follows stored representation rules",
        arguments: [
            (Fraction<Int>.zero, Fraction<Int>.zero),
            (Fraction<Int>.negativeZero, Fraction<Int>.negativeZero),
            (Fraction<Int>(1, 1), Fraction<Int>(1, 1)),
            (Fraction<Int>(-1, 1), Fraction<Int>(-1, 1))
        ]
    )
    internal func addingToPositiveZeroFollowsStoredRepresentationRules(
        addend: Fraction<Int>,
        sum: Fraction<Int>
    ) {
        #expect(Fraction<Int>.zero + addend == sum)
    }
}
