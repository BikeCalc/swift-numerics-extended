// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Fraction Subtractable Tests")
internal struct FractionSubtractableTests {
    private static let subtractionArguments: [(Fraction<Int>, Fraction<Int>, Fraction<Int>)] = [
        (Fraction<Int>(2, 3), Fraction<Int>(1, 2), Fraction<Int>(1, 6)),
        (Fraction<Int>(3, 4), Fraction<Int>(1, 2), Fraction<Int>(2, 8)),
        (Fraction<Int>(-2, 3), Fraction<Int>(1, 2), Fraction<Int>(-7, 6)),
        (Fraction<Int>(-3, 4), Fraction<Int>(-1, 2), Fraction<Int>(-2, 8))
    ]

    @Test(
        "Subtraction succeeds",
        arguments: Self.subtractionArguments
    )
    internal func subtractionSucceeds(
        minuend: Fraction<Int>,
        subtrahend: Fraction<Int>,
        difference: Fraction<Int>
    ) {
        #expect(minuend - subtrahend == difference)
    }

    @Test(
        "Subtraction equal succeeds",
        arguments: Self.subtractionArguments
    )
    internal func subtractionEqualSucceeds(
        minuend: Fraction<Int>,
        subtrahend: Fraction<Int>,
        difference: Fraction<Int>
    ) {
        var runningDifference: Fraction<Int> = minuend
        runningDifference -= subtrahend
        #expect(runningDifference == difference)
    }

    @Test(
        "Subtracting succeeds",
        arguments: Self.subtractionArguments
    )
    internal func subtractingSucceeds(
        minuend: Fraction<Int>,
        subtrahend: Fraction<Int>,
        difference: Fraction<Int>
    ) {
        #expect(minuend.subtracting(subtrahend) == difference)
    }

    @Test(
        "Subtract succeeds",
        arguments: Self.subtractionArguments
    )
    internal func subtractSucceeds(
        minuend: Fraction<Int>,
        subtrahend: Fraction<Int>,
        difference: Fraction<Int>
    ) {
        var runningDifference: Fraction<Int> = minuend
        runningDifference.subtract(subtrahend)
        #expect(runningDifference == difference)
    }
}

extension FractionSubtractableTests {
    @Test(
        "Subtraction is not commutative",
        arguments: Self.subtractionArguments
    )
    internal func subtractionIsNotCommutative(
        minuend: Fraction<Int>,
        subtrahend: Fraction<Int>,
        difference _: Fraction<Int>
    ) {
        #expect(minuend - subtrahend != subtrahend - minuend)
    }
}

// MARK: - NaN

extension FractionSubtractableTests {
    @Test("Subtracting positive infinity from itself returns NaN")
    internal func subtractingPositiveInfinityFromItselfReturnsNaN() {
        #expect((Fraction<Int>.infinity - .infinity).isNaN == true)
    }

    @Test("Subtracting negative infinity from itself returns NaN")
    internal func subtractingNegativeInfinityFromItselfReturnsNaN() {
        #expect((Fraction<Int>.negativeInfinity - .negativeInfinity).isNaN == true)
    }

    @Test(
        "Subtracting from NaN returns NaN",
        arguments: [
            Fraction<Int>.nan,
            Fraction<Int>.zero,
            Fraction<Int>.negativeZero,
            Fraction<Int>(1, 1),
            Fraction<Int>.infinity,
            Fraction<Int>.negativeInfinity
        ]
    )
    internal func subtractingFromNaNReturnsNaN(subtrahend: Fraction<Int>) {
        #expect((Fraction<Int>.nan - subtrahend).isNaN == true)
    }

    @Test(
        "Subtracting NaN returns NaN",
        arguments: [
            Fraction<Int>.zero,
            Fraction<Int>.negativeZero,
            Fraction<Int>(1, 1),
            Fraction<Int>(-1, 1),
            Fraction<Int>.infinity,
            Fraction<Int>.negativeInfinity
        ]
    )
    internal func subtractingNaNReturnsNaN(minuend: Fraction<Int>) {
        #expect((minuend - Fraction<Int>.nan).isNaN == true)
    }
}

// MARK: - Negative Infinity

extension FractionSubtractableTests {
    @Test(
        "Subtracting negative infinity follows rational rules",
        arguments: [
            (Fraction<Int>.negativeInfinity, Fraction<Int>.infinity, Fraction<Int>.negativeInfinity),
            (Fraction<Int>.negativeInfinity, Fraction<Int>(1, 1), Fraction<Int>.negativeInfinity),
            (Fraction<Int>(1, 1), Fraction<Int>.negativeInfinity, Fraction<Int>.infinity)
        ]
    )
    internal func subtractingNegativeInfinityFollowsRationalRules(
        minuend: Fraction<Int>,
        subtrahend: Fraction<Int>,
        difference: Fraction<Int>
    ) {
        #expect(minuend - subtrahend == difference)
    }
}

// MARK: - Negative Zero

extension FractionSubtractableTests {
    @Test(
        "Subtracting from negative zero follows stored representation rules",
        arguments: [
            (Fraction<Int>.zero, Fraction<Int>.negativeZero),
            (Fraction<Int>.negativeZero, Fraction<Int>.negativeZero),
            (Fraction<Int>(1, 1), Fraction<Int>(1, -1)),
            (Fraction<Int>(-1, 1), Fraction<Int>(-1, -1))
        ]
    )
    internal func subtractingFromNegativeZeroFollowsStoredRepresentationRules(
        subtrahend: Fraction<Int>,
        difference: Fraction<Int>
    ) {
        #expect(Fraction<Int>.negativeZero - subtrahend == difference)
    }
}

// MARK: - Positive Infinity

extension FractionSubtractableTests {
    @Test(
        "Subtracting positive infinity follows rational rules",
        arguments: [
            (Fraction<Int>.infinity, Fraction<Int>.negativeInfinity, Fraction<Int>.infinity),
            (Fraction<Int>.infinity, Fraction<Int>(1, 1), Fraction<Int>.infinity),
            (Fraction<Int>(1, 1), Fraction<Int>.infinity, Fraction<Int>.negativeInfinity)
        ]
    )
    internal func subtractingPositiveInfinityFollowsRationalRules(
        minuend: Fraction<Int>,
        subtrahend: Fraction<Int>,
        difference: Fraction<Int>
    ) {
        #expect(minuend - subtrahend == difference)
    }
}

// MARK: - Positive Zero

extension FractionSubtractableTests {
    @Test(
        "Subtracting positive zero preserves minuend",
        arguments: [
            Fraction<Int>(2, 3),
            Fraction<Int>(3, 4),
            Fraction<Int>(-2, 3),
            Fraction<Int>(-3, 4)
        ]
    )
    internal func subtractingPositiveZeroPreservesMinuend(minuend: Fraction<Int>) {
        #expect(minuend - .zero == minuend)
    }

    @Test(
        "Subtracting from positive zero follows stored representation rules",
        arguments: [
            (Fraction<Int>.zero, Fraction<Int>.zero),
            (Fraction<Int>.negativeZero, Fraction<Int>.negativeZero),
            (Fraction<Int>(1, 1), Fraction<Int>(-1, 1)),
            (Fraction<Int>(-1, 1), Fraction<Int>(1, 1))
        ]
    )
    internal func subtractingFromPositiveZeroFollowsStoredRepresentationRules(
        subtrahend: Fraction<Int>,
        difference: Fraction<Int>
    ) {
        #expect(Fraction<Int>.zero - subtrahend == difference)
    }

    @Test(
        "Subtracting self returns positive zero",
        arguments: [
            Fraction<Int>(2, 3),
            Fraction<Int>(3, 4),
            Fraction<Int>(-2, 3),
            Fraction<Int>(-3, 4)
        ]
    )
    internal func subtractingSelfReturnsPositiveZero(value: Fraction<Int>) {
        let difference: Fraction<Int> = value - value
        #expect(difference.isZero == true)
        #expect(difference.denominator > 0)
    }
}
