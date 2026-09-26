// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Fraction Multipliable Tests")
internal struct FractionMultipliableTests {
    private static let multiplicationArguments: [(Fraction<Int>, Fraction<Int>, Fraction<Int>)] = [
        (Fraction<Int>(1, 2), Fraction<Int>(1, 2), Fraction<Int>(1, 4)),
        (Fraction<Int>(1, 2), Fraction<Int>(2, 3), Fraction<Int>(2, 6)),
        (Fraction<Int>(-1, 2), Fraction<Int>(1, 2), Fraction<Int>(-1, 4)),
        (Fraction<Int>(-1, 2), Fraction<Int>(-2, 3), Fraction<Int>(2, 6))
    ]

    private static let doublingArguments: [(Fraction<Int>, Fraction<Int>)] = [
        (Fraction<Int>(1, 2), Fraction<Int>(2, 2)),
        (Fraction<Int>(-1, 2), Fraction<Int>(-2, 2)),
        (Fraction<Int>(-1, -2), Fraction<Int>(-2, -2)),
        (Fraction<Int>(1, -2), Fraction<Int>(2, -2))
    ]

    @Test(
        "Is multiple of",
        arguments: [
            (Fraction<Int>(1, 4), Fraction<Int>(1, 4), true),
            (Fraction<Int>(2, 6), Fraction<Int>(1, 4), false),
            (Fraction<Int>(-1, 4), Fraction<Int>(1, 4), true),
            (Fraction<Int>(-2, 6), Fraction<Int>(1, 4), false)
        ]
    )
    internal func isMultipleOf(
        value: Fraction<Int>,
        other: Fraction<Int>,
        result: Bool
    ) {
        #expect(value.isMultiple(of: other) == result)
    }

    @Test(
        "Multiplication succeeds",
        arguments: Self.multiplicationArguments
    )
    internal func multiplicationSucceeds(
        multiplicand: Fraction<Int>,
        multiplier: Fraction<Int>,
        product: Fraction<Int>
    ) {
        #expect(multiplicand * multiplier == product)
    }

    @Test(
        "Multiplication equal succeeds",
        arguments: Self.multiplicationArguments
    )
    internal func multiplicationEqualSucceeds(
        multiplicand: Fraction<Int>,
        multiplier: Fraction<Int>,
        product: Fraction<Int>
    ) {
        var runningProduct: Fraction<Int> = multiplicand
        runningProduct *= multiplier
        #expect(runningProduct == product)
    }

    @Test(
        "Multiplying by succeeds",
        arguments: Self.multiplicationArguments
    )
    internal func multiplyingBySucceeds(
        multiplicand: Fraction<Int>,
        multiplier: Fraction<Int>,
        product: Fraction<Int>
    ) {
        #expect(multiplicand.multiplying(by: multiplier) == product)
    }

    @Test(
        "Multiply by succeeds",
        arguments: Self.multiplicationArguments
    )
    internal func multiplyBySucceeds(
        multiplicand: Fraction<Int>,
        multiplier: Fraction<Int>,
        product: Fraction<Int>
    ) {
        var runningProduct: Fraction<Int> = multiplicand
        runningProduct.multiply(by: multiplier)
        #expect(runningProduct == product)
    }

    @Test(
        "Doubled succeeds",
        arguments: Self.doublingArguments
    )
    internal func doubledSucceeds(
        multiplicand: Fraction<Int>,
        product: Fraction<Int>
    ) {
        #expect(multiplicand.doubled() == product)
    }

    @Test(
        "Double succeeds",
        arguments: Self.doublingArguments
    )
    internal func doubleSucceeds(
        multiplicand: Fraction<Int>,
        product: Fraction<Int>
    ) {
        var runningProduct: Fraction<Int> = multiplicand
        runningProduct.double()
        #expect(runningProduct == product)
    }
}

extension FractionMultipliableTests {
    @Test(
        "Multiplication is commutative",
        arguments: Self.multiplicationArguments
    )
    internal func multiplicationIsCommutative(
        multiplicand: Fraction<Int>,
        multiplier: Fraction<Int>,
        product _: Fraction<Int>
    ) {
        #expect(multiplicand * multiplier == multiplier * multiplicand)
    }
}

// MARK: - NaN

extension FractionMultipliableTests {
    @Test(
        "NaN multiple predicate follows rational rules",
        arguments: [
            Fraction<Int>.zero,
            Fraction<Int>.negativeZero,
            Fraction<Int>(2, 1),
            Fraction<Int>.infinity,
            Fraction<Int>.negativeInfinity
        ]
    )
    internal func nanMultiplePredicateFollowsRationalRules(other: Fraction<Int>) {
        #expect(Fraction<Int>.nan.isMultiple(of: other) == false)
        #expect(other.isMultiple(of: .nan) == false)
    }

    @Test(
        "Multiplying positive zero by infinity returns NaN",
        arguments: [
            (Fraction<Int>.zero, Fraction<Int>.infinity),
            (Fraction<Int>.zero, Fraction<Int>.negativeInfinity),
            (Fraction<Int>.infinity, Fraction<Int>.zero),
            (Fraction<Int>.negativeInfinity, Fraction<Int>.zero)
        ]
    )
    internal func multiplyingPositiveZeroByInfinityReturnsNaN(
        multiplicand: Fraction<Int>,
        multiplier: Fraction<Int>
    ) {
        #expect((multiplicand * multiplier).isNaN == true)
    }

    @Test(
        "Multiplying negative zero by infinity returns NaN",
        arguments: [
            (Fraction<Int>.negativeZero, Fraction<Int>.infinity),
            (Fraction<Int>.negativeZero, Fraction<Int>.negativeInfinity),
            (Fraction<Int>.infinity, Fraction<Int>.negativeZero),
            (Fraction<Int>.negativeInfinity, Fraction<Int>.negativeZero)
        ]
    )
    internal func multiplyingNegativeZeroByInfinityReturnsNaN(
        multiplicand: Fraction<Int>,
        multiplier: Fraction<Int>
    ) {
        #expect((multiplicand * multiplier).isNaN == true)
    }

    @Test(
        "Multiplying NaN returns NaN",
        arguments: [
            Fraction<Int>.nan,
            Fraction<Int>.zero,
            Fraction<Int>.negativeZero,
            Fraction<Int>(1, 1),
            Fraction<Int>.infinity,
            Fraction<Int>.negativeInfinity
        ]
    )
    internal func multiplyingNaNReturnsNaN(multiplier: Fraction<Int>) {
        #expect((Fraction<Int>.nan * multiplier).isNaN == true)
    }

    @Test(
        "Multiplying by NaN returns NaN",
        arguments: [
            Fraction<Int>.zero,
            Fraction<Int>.negativeZero,
            Fraction<Int>(1, 1),
            Fraction<Int>(-1, 1),
            Fraction<Int>.infinity,
            Fraction<Int>.negativeInfinity
        ]
    )
    internal func multiplyingByNaNReturnsNaN(multiplicand: Fraction<Int>) {
        #expect((multiplicand * Fraction<Int>.nan).isNaN == true)
    }
}

// MARK: - Negative Infinity

extension FractionMultipliableTests {
    @Test(
        "Negative infinity multiple predicate follows rational rules",
        arguments: [
            Fraction<Int>.zero,
            Fraction<Int>.negativeZero,
            Fraction<Int>(2, 1),
            Fraction<Int>.infinity,
            Fraction<Int>.negativeInfinity
        ]
    )
    internal func negativeInfinityMultiplePredicateFollowsRationalRules(other: Fraction<Int>) {
        #expect(Fraction<Int>.negativeInfinity.isMultiple(of: other) == false)
    }

    @Test(
        "Multiplying negative infinity follows rational rules",
        arguments: [
            (Fraction<Int>.infinity, Fraction<Int>.negativeInfinity),
            (Fraction<Int>.negativeInfinity, Fraction<Int>.infinity),
            (Fraction<Int>(1, 1), Fraction<Int>.negativeInfinity),
            (Fraction<Int>(-1, 1), Fraction<Int>.infinity)
        ]
    )
    internal func multiplyingNegativeInfinityFollowsRationalRules(
        multiplier: Fraction<Int>,
        product: Fraction<Int>
    ) {
        #expect(Fraction<Int>.negativeInfinity * multiplier == product)
    }
}

// MARK: - Negative One

extension FractionMultipliableTests {
    @Test(
        "Multiplying by negative one returns opposite value",
        arguments: [
            (Fraction<Int>(1, 2), Fraction<Int>(-1, 2)),
            (Fraction<Int>(2, 3), Fraction<Int>(-2, 3)),
            (Fraction<Int>(-1, 2), Fraction<Int>(1, 2)),
            (Fraction<Int>(-2, 3), Fraction<Int>(2, 3))
        ]
    )
    internal func multiplyingByNegativeOneReturnsOppositeValue(
        multiplicand: Fraction<Int>,
        product: Fraction<Int>
    ) {
        #expect(multiplicand * -1 == product)
    }
}

// MARK: - Negative Zero

extension FractionMultipliableTests {
    @Test(
        "Is multiple of negative zero returns false",
        arguments: [
            Fraction<Int>(1, 2),
            Fraction<Int>(2, 3),
            Fraction<Int>(-1, 2),
            Fraction<Int>(-2, 3)
        ]
    )
    internal func isMultipleOfNegativeZeroReturnsFalse(multiplicand: Fraction<Int>) {
        #expect(multiplicand.isMultiple(of: .negativeZero) == false)
    }

    @Test(
        "Negative zero multiple predicate follows rational rules",
        arguments: [
            (Fraction<Int>.zero, true),
            (Fraction<Int>.negativeZero, true),
            (Fraction<Int>(2, 1), true),
            (Fraction<Int>.infinity, false),
            (Fraction<Int>.negativeInfinity, false)
        ]
    )
    internal func negativeZeroMultiplePredicateFollowsRationalRules(
        other: Fraction<Int>,
        result: Bool
    ) {
        #expect(Fraction<Int>.negativeZero.isMultiple(of: other) == result)
    }

    @Test(
        "Multiplying negative zero follows stored representation rules",
        arguments: [
            (Fraction<Int>.zero, Fraction<Int>.negativeZero),
            (Fraction<Int>.negativeZero, Fraction<Int>.zero),
            (Fraction<Int>(1, 1), Fraction<Int>.negativeZero),
            (Fraction<Int>(-1, 1), Fraction<Int>.negativeZero)
        ]
    )
    internal func multiplyingNegativeZeroFollowsStoredRepresentationRules(
        multiplier: Fraction<Int>,
        product: Fraction<Int>
    ) {
        #expect(Fraction<Int>.negativeZero * multiplier == product)
    }
}

// MARK: - Positive Infinity

extension FractionMultipliableTests {
    @Test(
        "Positive infinity multiple predicate follows rational rules",
        arguments: [
            Fraction<Int>.zero,
            Fraction<Int>.negativeZero,
            Fraction<Int>(2, 1),
            Fraction<Int>.infinity,
            Fraction<Int>.negativeInfinity
        ]
    )
    internal func positiveInfinityMultiplePredicateFollowsRationalRules(other: Fraction<Int>) {
        #expect(Fraction<Int>.infinity.isMultiple(of: other) == false)
    }

    @Test(
        "Multiplying positive infinity follows rational rules",
        arguments: [
            (Fraction<Int>.infinity, Fraction<Int>.infinity),
            (Fraction<Int>.negativeInfinity, Fraction<Int>.negativeInfinity),
            (Fraction<Int>(1, 1), Fraction<Int>.infinity),
            (Fraction<Int>(-1, 1), Fraction<Int>.negativeInfinity)
        ]
    )
    internal func multiplyingPositiveInfinityFollowsRationalRules(
        multiplier: Fraction<Int>,
        product: Fraction<Int>
    ) {
        #expect(Fraction<Int>.infinity * multiplier == product)
    }
}

// MARK: - Positive One

extension FractionMultipliableTests {
    @Test(
        "Multiplying by positive one preserves multiplicand",
        arguments: [
            Fraction<Int>(1, 2),
            Fraction<Int>(2, 3),
            Fraction<Int>(-1, 2),
            Fraction<Int>(-2, 3)
        ]
    )
    internal func multiplyingByPositiveOnePreservesMultiplicand(multiplicand: Fraction<Int>) {
        #expect(multiplicand * 1 == multiplicand)
    }
}

// MARK: - Positive Zero

extension FractionMultipliableTests {
    @Test(
        "Is multiple of positive zero returns false",
        arguments: [
            Fraction<Int>(1, 2),
            Fraction<Int>(2, 3),
            Fraction<Int>(-1, 2),
            Fraction<Int>(-2, 3)
        ]
    )
    internal func isMultipleOfPositiveZeroReturnsFalse(multiplicand: Fraction<Int>) {
        #expect(multiplicand.isMultiple(of: .zero) == false)
    }

    @Test(
        "Multiplying by positive zero returns positive or negative zero",
        arguments: [
            Fraction<Int>(1, 2),
            Fraction<Int>(2, 3),
            Fraction<Int>(-1, 2),
            Fraction<Int>(-2, 3)
        ]
    )
    internal func multiplyingByPositiveZeroReturnsPositiveOrNegativeZero(multiplicand: Fraction<Int>) {
        #expect((multiplicand * .zero).isZero == true)
    }

    @Test(
        "Positive zero multiple predicate follows rational rules",
        arguments: [
            (Fraction<Int>.zero, true),
            (Fraction<Int>.negativeZero, true),
            (Fraction<Int>(2, 1), true),
            (Fraction<Int>.infinity, false),
            (Fraction<Int>.negativeInfinity, false)
        ]
    )
    internal func positiveZeroMultiplePredicateFollowsRationalRules(
        other: Fraction<Int>,
        result: Bool
    ) {
        #expect(Fraction<Int>.zero.isMultiple(of: other) == result)
    }

    @Test(
        "Multiplying positive zero follows stored representation rules",
        arguments: [
            (Fraction<Int>.zero, Fraction<Int>.zero),
            (Fraction<Int>.negativeZero, Fraction<Int>.negativeZero),
            (Fraction<Int>(1, 1), Fraction<Int>.zero),
            (Fraction<Int>(-1, 1), Fraction<Int>.zero)
        ]
    )
    internal func multiplyingPositiveZeroFollowsStoredRepresentationRules(
        multiplier: Fraction<Int>,
        product: Fraction<Int>
    ) {
        #expect(Fraction<Int>.zero * multiplier == product)
    }
}
