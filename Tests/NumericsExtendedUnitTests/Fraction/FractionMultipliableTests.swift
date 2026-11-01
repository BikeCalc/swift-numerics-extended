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
    internal init() {}

    private static let multiplicationArguments: [(Fraction<Int>, Fraction<Int>.Multiplier, Fraction<Int>)] = [
        (.init(1, 2), .init(1, 2), .init(1, 4)),
        (.init(1, 2), .init(2, 3), .init(2, 6)),
        (.init(-1, 2), .init(1, 2), .init(-1, 4)),
        (.init(-1, 2), .init(-2, 3), .init(2, 6))
    ]

    private static let doublingArguments: [(Fraction<Int>, Fraction<Int>)] = [
        (.init(1, 2), .init(2, 2)),
        (.init(-1, 2), .init(-2, 2)),
        (.init(-1, -2), .init(-2, -2)),
        (.init(1, -2), .init(2, -2))
    ]

    @Test(
        "Is multiple of",
        arguments: [
            (.init(1, 4), .init(1, 4), true),
            (.init(2, 6), .init(1, 4), false),
            (.init(-1, 4), .init(1, 4), true),
            (.init(-2, 6), .init(1, 4), false)
        ] as Array<(Fraction<Int>, Fraction<Int>, Bool)>
    )
    internal func isMultipleOf(
        value: Fraction<Int>,
        other: Fraction<Int>,
        expected: Bool
    ) {
        let result: Bool = value.isMultiple(of: other)
        #expect(result == expected)
    }

    @Test(
        "Multiplication succeeds",
        arguments: Self.multiplicationArguments
    )
    internal func multiplicationSucceeds(
        multiplicand: Fraction<Int>,
        multiplier: Fraction<Int>.Multiplier,
        product: Fraction<Int>
    ) {
        let result: Fraction<Int> = multiplicand * multiplier
        #expect(result == product)
    }

    @Test(
        "Multiplication equal succeeds",
        arguments: Self.multiplicationArguments
    )
    internal func multiplicationEqualSucceeds(
        multiplicand: Fraction<Int>,
        multiplier: Fraction<Int>.Multiplier,
        product: Fraction<Int>
    ) {
        var result: Fraction<Int> = multiplicand
        result *= multiplier
        #expect(result == product)
    }

    @Test(
        "Multiplying by succeeds",
        arguments: Self.multiplicationArguments
    )
    internal func multiplyingBySucceeds(
        multiplicand: Fraction<Int>,
        multiplier: Fraction<Int>.Multiplier,
        product: Fraction<Int>
    ) throws {
        let result: Fraction<Int> = try multiplicand.multiplying(by: multiplier)
        #expect(result == product)
    }

    @Test(
        "Multiply by succeeds",
        arguments: Self.multiplicationArguments
    )
    internal func multiplyBySucceeds(
        multiplicand: Fraction<Int>,
        multiplier: Fraction<Int>.Multiplier,
        product: Fraction<Int>
    ) throws {
        var result: Fraction<Int> = multiplicand
        try result.multiply(by: multiplier)
        #expect(result == product)
    }

    @Test(
        "Doubled succeeds",
        arguments: Self.doublingArguments
    )
    internal func doubledSucceeds(
        multiplicand: Fraction<Int>,
        product: Fraction<Int>
    ) {
        let result: Fraction<Int> = multiplicand.doubled()
        #expect(result == product)
    }

    @Test(
        "Double succeeds",
        arguments: Self.doublingArguments
    )
    internal func doubleSucceeds(
        multiplicand: Fraction<Int>,
        product: Fraction<Int>
    ) {
        var result: Fraction<Int> = multiplicand
        result.double()
        #expect(result == product)
    }
}

extension FractionMultipliableTests {
    @Test(
        "Multiplication is commutative",
        arguments: Self.multiplicationArguments
    )
    internal func multiplicationIsCommutative(
        multiplicand: Fraction<Int>,
        multiplier: Fraction<Int>.Multiplier,
        product _: Fraction<Int>
    ) {
        let result: Fraction<Int> = multiplicand * multiplier
        #expect(result == multiplier * multiplicand)
    }
}

// MARK: - NaN

extension FractionMultipliableTests {
    @Test(
        "NaN multiple predicate follows rational rules",
        arguments: [
            .zero,
            .negativeZero,
            .init(2, 1),
            .infinity,
            .negativeInfinity
        ] as Array<Fraction<Int>>
    )
    internal func nanMultiplePredicateFollowsRationalRules(other: Fraction<Int>) {
        let firstResult: Bool = Fraction<Int>.nan.isMultiple(of: other)
        #expect(firstResult == false)
        let secondResult: Bool = other.isMultiple(of: .nan)
        #expect(secondResult == false)
    }

    @Test(
        "Multiplying positive zero by infinity returns NaN",
        arguments: [
            (.zero, .infinity),
            (.zero, .negativeInfinity),
            (.infinity, .zero),
            (.negativeInfinity, .zero)
        ] as Array<(Fraction<Int>, Fraction<Int>.Multiplier)>
    )
    internal func multiplyingPositiveZeroByInfinityReturnsNaN(
        multiplicand: Fraction<Int>,
        multiplier: Fraction<Int>.Multiplier
    ) {
        let result: Fraction<Int> = multiplicand * multiplier
        #expect(result.isNaN == true)
    }

    @Test(
        "Multiplying negative zero by infinity returns NaN",
        arguments: [
            (.negativeZero, .infinity),
            (.negativeZero, .negativeInfinity),
            (.infinity, .negativeZero),
            (.negativeInfinity, .negativeZero)
        ] as Array<(Fraction<Int>, Fraction<Int>.Multiplier)>
    )
    internal func multiplyingNegativeZeroByInfinityReturnsNaN(
        multiplicand: Fraction<Int>,
        multiplier: Fraction<Int>.Multiplier
    ) {
        let result: Fraction<Int> = multiplicand * multiplier
        #expect(result.isNaN == true)
    }

    @Test(
        "Multiplying NaN returns NaN",
        arguments: [
            .nan,
            .zero,
            .negativeZero,
            .init(1, 1),
            .infinity,
            .negativeInfinity
        ] as Array<Fraction<Int>.Multiplier>
    )
    internal func multiplyingNaNReturnsNaN(multiplier: Fraction<Int>.Multiplier) {
        let result: Fraction<Int> = Fraction<Int>.nan * multiplier
        #expect(result.isNaN == true)
    }

    @Test(
        "Multiplying by NaN returns NaN",
        arguments: [
            .zero,
            .negativeZero,
            .init(1, 1),
            .init(-1, 1),
            .infinity,
            .negativeInfinity
        ] as Array<Fraction<Int>>
    )
    internal func multiplyingByNaNReturnsNaN(multiplicand: Fraction<Int>) {
        let result: Fraction<Int> = multiplicand * Fraction<Int>.nan
        #expect(result.isNaN == true)
    }
}

// MARK: - Negative Infinity

extension FractionMultipliableTests {
    @Test(
        "Negative infinity multiple predicate follows rational rules",
        arguments: [
            .zero,
            .negativeZero,
            .init(2, 1),
            .infinity,
            .negativeInfinity
        ] as Array<Fraction<Int>>
    )
    internal func negativeInfinityMultiplePredicateFollowsRationalRules(other: Fraction<Int>) {
        let result: Bool = Fraction<Int>.negativeInfinity.isMultiple(of: other)
        #expect(result == false)
    }

    @Test(
        "Multiplying negative infinity follows rational rules",
        arguments: [
            (.infinity, .negativeInfinity),
            (.negativeInfinity, .infinity),
            (.init(1, 1), .negativeInfinity),
            (.init(-1, 1), .infinity)
        ] as Array<(Fraction<Int>.Multiplier, Fraction<Int>)>
    )
    internal func multiplyingNegativeInfinityFollowsRationalRules(
        multiplier: Fraction<Int>.Multiplier,
        product: Fraction<Int>
    ) {
        let result: Fraction<Int> = Fraction<Int>.negativeInfinity * multiplier
        #expect(result == product)
    }
}

// MARK: - Negative One

extension FractionMultipliableTests {
    @Test(
        "Multiplying by negative one returns opposite value",
        arguments: [
            (.init(1, 2), .init(-1, 2)),
            (.init(2, 3), .init(-2, 3)),
            (.init(-1, 2), .init(1, 2)),
            (.init(-2, 3), .init(2, 3))
        ] as Array<(Fraction<Int>, Fraction<Int>)>
    )
    internal func multiplyingByNegativeOneReturnsOppositeValue(
        multiplicand: Fraction<Int>,
        product: Fraction<Int>
    ) {
        let result: Fraction<Int> = multiplicand * -1
        #expect(result == product)
    }
}

// MARK: - Negative Zero

extension FractionMultipliableTests {
    @Test(
        "Is multiple of negative zero returns false",
        arguments: [
            .init(1, 2),
            .init(2, 3),
            .init(-1, 2),
            .init(-2, 3)
        ] as Array<Fraction<Int>>
    )
    internal func isMultipleOfNegativeZeroReturnsFalse(multiplicand: Fraction<Int>) {
        let result: Bool = multiplicand.isMultiple(of: .negativeZero)
        #expect(result == false)
    }

    @Test(
        "Negative zero multiple predicate follows rational rules",
        arguments: [
            (.zero, true),
            (.negativeZero, true),
            (.init(2, 1), true),
            (.infinity, false),
            (.negativeInfinity, false)
        ] as Array<(Fraction<Int>, Bool)>
    )
    internal func negativeZeroMultiplePredicateFollowsRationalRules(
        other: Fraction<Int>,
        expected: Bool
    ) {
        let result: Bool = Fraction<Int>.negativeZero.isMultiple(of: other)
        #expect(result == expected)
    }

    @Test(
        "Multiplying negative zero follows stored representation rules",
        arguments: [
            (.zero, .negativeZero),
            (.negativeZero, .zero),
            (.init(1, 1), .negativeZero),
            (.init(-1, 1), .negativeZero)
        ] as Array<(Fraction<Int>.Multiplier, Fraction<Int>)>
    )
    internal func multiplyingNegativeZeroFollowsStoredRepresentationRules(
        multiplier: Fraction<Int>.Multiplier,
        product: Fraction<Int>
    ) {
        let result: Fraction<Int> = Fraction<Int>.negativeZero * multiplier
        #expect(result == product)
    }
}

// MARK: - Positive Infinity

extension FractionMultipliableTests {
    @Test(
        "Positive infinity multiple predicate follows rational rules",
        arguments: [
            .zero,
            .negativeZero,
            .init(2, 1),
            .infinity,
            .negativeInfinity
        ] as Array<Fraction<Int>>
    )
    internal func positiveInfinityMultiplePredicateFollowsRationalRules(other: Fraction<Int>) {
        let result: Bool = Fraction<Int>.infinity.isMultiple(of: other)
        #expect(result == false)
    }

    @Test(
        "Multiplying positive infinity follows rational rules",
        arguments: [
            (.infinity, .infinity),
            (.negativeInfinity, .negativeInfinity),
            (.init(1, 1), .infinity),
            (.init(-1, 1), .negativeInfinity)
        ] as Array<(Fraction<Int>.Multiplier, Fraction<Int>)>
    )
    internal func multiplyingPositiveInfinityFollowsRationalRules(
        multiplier: Fraction<Int>.Multiplier,
        product: Fraction<Int>
    ) {
        let result: Fraction<Int> = Fraction<Int>.infinity * multiplier
        #expect(result == product)
    }
}

// MARK: - Positive One

extension FractionMultipliableTests {
    @Test(
        "Multiplying by positive one preserves multiplicand",
        arguments: [
            .init(1, 2),
            .init(2, 3),
            .init(-1, 2),
            .init(-2, 3)
        ] as Array<Fraction<Int>>
    )
    internal func multiplyingByPositiveOnePreservesMultiplicand(multiplicand: Fraction<Int>) {
        let result: Fraction<Int> = multiplicand * 1
        #expect(result == multiplicand)
    }
}

// MARK: - Positive Zero

extension FractionMultipliableTests {
    @Test(
        "Is multiple of positive zero returns false",
        arguments: [
            .init(1, 2),
            .init(2, 3),
            .init(-1, 2),
            .init(-2, 3)
        ] as Array<Fraction<Int>>
    )
    internal func isMultipleOfPositiveZeroReturnsFalse(multiplicand: Fraction<Int>) {
        let result: Bool = multiplicand.isMultiple(of: .zero)
        #expect(result == false)
    }

    @Test(
        "Multiplying by positive zero returns positive or negative zero",
        arguments: [
            .init(1, 2),
            .init(2, 3),
            .init(-1, 2),
            .init(-2, 3)
        ] as Array<Fraction<Int>>
    )
    internal func multiplyingByPositiveZeroReturnsPositiveOrNegativeZero(multiplicand: Fraction<Int>) {
        let result: Fraction<Int> = multiplicand * .zero
        #expect(result.isZero == true)
    }

    @Test(
        "Positive zero multiple predicate follows rational rules",
        arguments: [
            (.zero, true),
            (.negativeZero, true),
            (.init(2, 1), true),
            (.infinity, false),
            (.negativeInfinity, false)
        ] as Array<(Fraction<Int>, Bool)>
    )
    internal func positiveZeroMultiplePredicateFollowsRationalRules(
        other: Fraction<Int>,
        expected: Bool
    ) {
        let result: Bool = Fraction<Int>.zero.isMultiple(of: other)
        #expect(result == expected)
    }

    @Test(
        "Multiplying positive zero follows stored representation rules",
        arguments: [
            (.zero, .zero),
            (.negativeZero, .negativeZero),
            (.init(1, 1), .zero),
            (.init(-1, 1), .zero)
        ] as Array<(Fraction<Int>.Multiplier, Fraction<Int>)>
    )
    internal func multiplyingPositiveZeroFollowsStoredRepresentationRules(
        multiplier: Fraction<Int>.Multiplier,
        product: Fraction<Int>
    ) {
        let result: Fraction<Int> = Fraction<Int>.zero * multiplier
        #expect(result == product)
    }
}
