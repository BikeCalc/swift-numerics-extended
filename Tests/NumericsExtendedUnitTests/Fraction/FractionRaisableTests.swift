// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Fraction Raisable Tests")
internal struct FractionRaisableTests {
    internal init() {}

    private static let exponentiationArguments: [(Fraction<Int>, Fraction<Int>.Exponent, Fraction<Int>)] = [
        (Fraction<Int>(2, 3), 2, Fraction<Int>(4, 9)),
        (Fraction<Int>(2, 3), 3, Fraction<Int>(8, 27)),
        (Fraction<Int>(2, 3), -2, Fraction<Int>(9, 4)),
        (Fraction<Int>(2, 3), -3, Fraction<Int>(27, 8)),
        (Fraction<Int>(-2, 3), 2, Fraction<Int>(4, 9)),
        (Fraction<Int>(-2, 3), 3, Fraction<Int>(-8, 27)),
        (Fraction<Int>(-2, 3), -2, Fraction<Int>(9, 4)),
        (Fraction<Int>(-2, 3), -3, Fraction<Int>(27, -8)),
        (Fraction<Int>(1, 1), -2, Fraction<Int>(1, 1)),
        (Fraction<Int>(1, 1), -3, Fraction<Int>(1, 1)),
        (Fraction<Int>(-1, 1), -2, Fraction<Int>(1, 1)),
        (Fraction<Int>(-1, 1), -3, Fraction<Int>(1, -1))
    ]

    private static let squaringArguments: [(Fraction<Int>, Fraction<Int>)] = [
        (Fraction<Int>(2, 3), Fraction<Int>(4, 9)),
        (Fraction<Int>(3, 4), Fraction<Int>(9, 16)),
        (Fraction<Int>(-2, 3), Fraction<Int>(4, 9)),
        (Fraction<Int>(-3, 4), Fraction<Int>(9, 16))
    ]

    private static let cubingArguments: [(Fraction<Int>, Fraction<Int>)] = [
        (Fraction<Int>(2, 3), Fraction<Int>(8, 27)),
        (Fraction<Int>(3, 4), Fraction<Int>(27, 64)),
        (Fraction<Int>(-2, 3), Fraction<Int>(-8, 27)),
        (Fraction<Int>(-3, 4), Fraction<Int>(-27, 64))
    ]

    @Test(
        "Is power of",
        arguments: [
            (Fraction<Int>(4, 1), Fraction<Int>(2, 1), true),
            (Fraction<Int>(6, 1), Fraction<Int>(2, 1), false),
            (Fraction<Int>(8, 1), Fraction<Int>(2, 1), true),
            (Fraction<Int>(9, 1), Fraction<Int>(2, 1), false),
            (Fraction<Int>(4, 1), Fraction<Int>(-2, 1), true),
            (Fraction<Int>(-8, 1), Fraction<Int>(-2, 1), true),
            (Fraction<Int>(6, 1), Fraction<Int>(-2, 1), false),
            (Fraction<Int>(1, 4), Fraction<Int>(2, 1), true),
            (Fraction<Int>(4, 1), Fraction<Int>(1, 2), true),
            (Fraction<Int>(-1, 8), Fraction<Int>(-2, 1), true),
            (Fraction<Int>(1, 8), Fraction<Int>(-2, 1), false)
        ]
    )
    internal func isPowerOf(
        value: Fraction<Int>,
        other: Fraction<Int>,
        expected: Bool
    ) {
        let result: Bool = value.isPower(of: other)
        #expect(result == expected)
    }

    @Test(
        "Exponentiation succeeds",
        arguments: Self.exponentiationArguments
    )
    internal func exponentiationSucceeds(
        base: Fraction<Int>,
        exponent: Fraction<Int>.Exponent,
        power: Fraction<Int>
    ) {
        let result: Fraction<Int> = base ** exponent
        #expect(result == power)
    }

    @Test(
        "Exponentiation equal succeeds",
        arguments: Self.exponentiationArguments
    )
    internal func exponentiationEqualSucceeds(
        base: Fraction<Int>,
        exponent: Fraction<Int>.Exponent,
        power: Fraction<Int>
    ) {
        var result: Fraction<Int> = base
        result **= exponent
        #expect(result == power)
    }

    @Test(
        "Raising to succeeds",
        arguments: Self.exponentiationArguments
    )
    internal func raisingToSucceeds(
        base: Fraction<Int>,
        exponent: Fraction<Int>.Exponent,
        power: Fraction<Int>
    ) throws {
        let result: Fraction<Int> = try base.raising(to: exponent)
        #expect(result == power)
    }

    @Test(
        "Raise to succeeds",
        arguments: Self.exponentiationArguments
    )
    internal func raiseToSucceeds(
        base: Fraction<Int>,
        exponent: Fraction<Int>.Exponent,
        power: Fraction<Int>
    ) throws {
        var result: Fraction<Int> = base
        try result.raise(to: exponent)
        #expect(result == power)
    }

    @Test(
        "Squared succeeds",
        arguments: Self.squaringArguments
    )
    internal func squaredSucceeds(
        base: Fraction<Int>,
        power: Fraction<Int>
    ) {
        let result: Fraction<Int> = base.squared()
        #expect(result == power)
    }

    @Test(
        "Square succeeds",
        arguments: Self.squaringArguments
    )
    internal func squareSucceeds(
        base: Fraction<Int>,
        power: Fraction<Int>
    ) {
        var result: Fraction<Int> = base
        result.square()
        #expect(result == power)
    }

    @Test(
        "Cubed succeeds",
        arguments: Self.cubingArguments
    )
    internal func cubedSucceeds(
        base: Fraction<Int>,
        power: Fraction<Int>
    ) {
        let result: Fraction<Int> = base.cubed()
        #expect(result == power)
    }

    @Test(
        "Cube succeeds",
        arguments: Self.cubingArguments
    )
    internal func cubeSucceeds(
        base: Fraction<Int>,
        power: Fraction<Int>
    ) {
        var result: Fraction<Int> = base
        result.cube()
        #expect(result == power)
    }
}

extension FractionRaisableTests {
    @Test(
        "Exponentiation is not commutative",
        arguments: [
            (Fraction<Int>(2, 1), 3),
            (Fraction<Int>(3, 1), 2),
            (Fraction<Int>(-2, 1), 3),
            (Fraction<Int>(2, 1), -2)
        ]
    )
    internal func exponentiationIsNotCommutative(
        base: Fraction<Int>,
        exponent: Fraction<Int>.Exponent
    ) {
        let result: Fraction<Int> = base ** exponent
        let reversedResult: Fraction<Int> = Fraction<Int>(exponent, 1) ** base.numerator
        #expect(result != reversedResult)
    }
}

// MARK: - IntMin

extension FractionRaisableTests {
    @Test(
        "Raising to negative one returns reciprocal",
        arguments: [
            (Fraction<Int>(1, 1), Fraction<Int>(1, 1)),
            (Fraction<Int>(-1, 1), Fraction<Int>(1, -1)),
            (Fraction<Int>(2, 3), Fraction<Int>(3, 2)),
            (Fraction<Int>(-2, 3), Fraction<Int>(3, -2))
        ]
    )
    internal func raisingToNegativeOneReturnsReciprocal(
        base: Fraction<Int>,
        power: Fraction<Int>
    ) {
        let result: Fraction<Int> = base ** -1
        #expect(result == power)
    }

    @Test("Int minimum exponent uses unsigned magnitude")
    internal func intMinimumExponentUsesUnsignedMagnitude() {
        let firstResult: Fraction<Int> = Fraction<Int>(1, 1) ** Int.min
        #expect(firstResult == .one)
        let secondResult: Fraction<Int> = Fraction<Int>(-1, 1) ** Int.min
        #expect(secondResult == .one)
    }
}

// MARK: - NaN

extension FractionRaisableTests {
    @Test("NaN power predicate follows rational rules")
    internal func nanPowerPredicateFollowsRationalRules() {
        let firstResult: Bool = Fraction<Int>(1, 1).isPower(of: .nan)
        #expect(firstResult == true)
        let secondResult: Bool = Fraction<Int>(2, 1).isPower(of: .nan)
        #expect(secondResult == false)
        let thirdResult: Bool = Fraction<Int>.nan.isPower(of: Fraction<Int>(2, 1))
        #expect(thirdResult == false)
    }

    @Test(
        "NaN raised to nonzero exponent returns NaN",
        arguments: [
            (Fraction<Int>.nan, 1),
            (Fraction<Int>.nan, 2),
            (Fraction<Int>.nan, -1)
        ]
    )
    internal func nanRaisedToNonzeroExponentReturnsNaN(
        base: Fraction<Int>,
        exponent: Fraction<Int>.Exponent
    ) {
        let result: Fraction<Int> = base ** exponent
        #expect(result.isNaN == true)
    }

    @Test("NaN raised to positive zero returns one")
    internal func nanRaisedToPositiveZeroReturnsOne() {
        let result: Fraction<Int> = .nan ** .zero
        #expect(result == .one)
    }

    @Test("NaN raised to negative zero returns one")
    internal func nanRaisedToNegativeZeroReturnsOne() {
        let result: Fraction<Int> = .nan ** Fraction<Int>.Exponent.negativeZero
        #expect(result == .one)
    }
}

// MARK: - Negative Infinity

extension FractionRaisableTests {
    @Test(
        "Raising to negative zero returns one",
        arguments: [
            Fraction<Int>(0, 1),
            Fraction<Int>(0, -2),
            Fraction<Int>(1, 1),
            Fraction<Int>(-1, 1),
            Fraction<Int>(2, 1),
            Fraction<Int>(3, 1),
            Fraction<Int>(-2, 1),
            Fraction<Int>(-3, 1)
        ]
    )
    internal func raisingToNegativeZeroReturnsOne(base: Fraction<Int>) {
        let result: Fraction<Int> = base ** Fraction<Int>.Exponent.negativeZero
        #expect(result == 1)
    }

    @Test(
        "Negative infinity base power predicate follows rational rules",
        arguments: [
            (Fraction<Int>(0, 1), true),
            (Fraction<Int>(0, -1), true),
            (Fraction<Int>(1, 1), true),
            (Fraction<Int>(2, 1), false),
            (Fraction<Int>.infinity, true),
            (Fraction<Int>.negativeInfinity, true)
        ]
    )
    internal func negativeInfinityBasePowerPredicateFollowsRationalRules(
        value: Fraction<Int>,
        expected: Bool
    ) {
        let result: Bool = value.isPower(of: .negativeInfinity)
        #expect(result == expected)
    }

    @Test(
        "Negative infinity exponentiation follows parity rule",
        arguments: [
            (Fraction<Int>.negativeInfinity, 0, Fraction<Int>(1, 1)),
            (Fraction<Int>.negativeInfinity, 1, Fraction<Int>.negativeInfinity),
            (Fraction<Int>.negativeInfinity, 2, Fraction<Int>.infinity),
            (Fraction<Int>.negativeInfinity, -1, Fraction<Int>(0, -1)),
            (Fraction<Int>.negativeInfinity, -2, Fraction<Int>(0, 1))
        ]
    )
    internal func negativeInfinityExponentiationFollowsParityRule(
        base: Fraction<Int>,
        exponent: Fraction<Int>.Exponent,
        power: Fraction<Int>
    ) {
        let result: Fraction<Int> = base ** exponent
        #expect(result == power)
    }
}

// MARK: - Negative One

extension FractionRaisableTests {
    @Test(
        "Negative one base exponentiation follows parity rule",
        arguments: [
            (0, Fraction<Int>(1, 1)),
            (1, Fraction<Int>(-1, 1)),
            (2, Fraction<Int>(1, 1)),
            (3, Fraction<Int>(-1, 1)),
            (-2, Fraction<Int>(1, 1)),
            (-3, Fraction<Int>(1, -1))
        ]
    )
    internal func negativeOneBaseExponentiationFollowsParityRule(
        exponent: Fraction<Int>.Exponent,
        power: Fraction<Int>
    ) {
        let result: Fraction<Int> = Fraction<Int>(-1, 1) ** exponent
        #expect(result == power)
    }

    @Test(
        "Negative one base power predicate follows signed rules",
        arguments: [
            (Fraction<Int>(1, 1), true),
            (Fraction<Int>(-1, 1), true),
            (Fraction<Int>(2, 1), false)
        ]
    )
    internal func negativeOneBasePowerPredicateFollowsSignedRules(
        value: Fraction<Int>,
        expected: Bool
    ) {
        let result: Bool = value.isPower(of: Fraction<Int>(-1, 1))
        #expect(result == expected)
    }
}

// MARK: - Negative Zero

extension FractionRaisableTests {
    @Test(
        "Negative zero base power predicate follows rational rules",
        arguments: [
            (Fraction<Int>(0, 1), true),
            (Fraction<Int>(0, -1), true),
            (Fraction<Int>(1, 1), true),
            (Fraction<Int>(2, 1), false),
            (Fraction<Int>.infinity, true),
            (Fraction<Int>.negativeInfinity, true)
        ]
    )
    internal func negativeZeroBasePowerPredicateFollowsRationalRules(
        value: Fraction<Int>,
        expected: Bool
    ) {
        let result: Bool = value.isPower(of: Fraction<Int>(0, -1))
        #expect(result == expected)
    }

    @Test(
        "Negative zero base exponentiation follows parity rule",
        arguments: [
            (Fraction<Int>(0, -1), 0, Fraction<Int>(1, 1)),
            (Fraction<Int>(0, -1), 1, Fraction<Int>(0, -1)),
            (Fraction<Int>(0, -1), 2, Fraction<Int>(0, 1)),
            (Fraction<Int>(0, -1), -1, Fraction<Int>.negativeInfinity),
            (Fraction<Int>(0, -1), -2, Fraction<Int>.infinity)
        ]
    )
    internal func negativeZeroBaseExponentiationFollowsParityRule(
        base: Fraction<Int>,
        exponent: Fraction<Int>.Exponent,
        power: Fraction<Int>
    ) {
        let result: Fraction<Int> = base ** exponent
        #expect(result == power)
    }
}

// MARK: - Positive Infinity

extension FractionRaisableTests {
    @Test(
        "Positive infinity base power predicate follows rational rules",
        arguments: [
            (Fraction<Int>(0, 1), true),
            (Fraction<Int>(0, -1), true),
            (Fraction<Int>(1, 1), true),
            (Fraction<Int>(2, 1), false),
            (Fraction<Int>.infinity, true),
            (Fraction<Int>.negativeInfinity, false)
        ]
    )
    internal func positiveInfinityBasePowerPredicateFollowsRationalRules(
        value: Fraction<Int>,
        expected: Bool
    ) {
        let result: Bool = value.isPower(of: .infinity)
        #expect(result == expected)
    }

    @Test(
        "Positive infinity exponentiation follows reciprocal rules",
        arguments: [
            (Fraction<Int>.infinity, 0, Fraction<Int>(1, 1)),
            (Fraction<Int>.infinity, 1, Fraction<Int>.infinity),
            (Fraction<Int>.infinity, -1, Fraction<Int>(0, 1))
        ]
    )
    internal func positiveInfinityExponentiationFollowsReciprocalRules(
        base: Fraction<Int>,
        exponent: Fraction<Int>.Exponent,
        power: Fraction<Int>
    ) {
        let result: Fraction<Int> = base ** exponent
        #expect(result == power)
    }
}

// MARK: - Positive One

extension FractionRaisableTests {
    @Test(
        "Raising to positive one preserves base",
        arguments: [
            Fraction<Int>(0, 1),
            Fraction<Int>(0, -2),
            Fraction<Int>(1, 1),
            Fraction<Int>(-1, 1),
            Fraction<Int>(2, 1),
            Fraction<Int>(3, 1),
            Fraction<Int>(-2, 1),
            Fraction<Int>(-3, 1)
        ]
    )
    internal func raisingToPositiveOnePreservesBase(base: Fraction<Int>) {
        let result: Fraction<Int> = base ** 1
        #expect(result == base)
    }

    @Test(
        "Positive one base exponentiation returns positive one",
        arguments: [
            0,
            1,
            2,
            3,
            -2,
            -3
        ]
    )
    internal func positiveOneBaseExponentiationReturnsPositiveOne(exponent: Fraction<Int>.Exponent) {
        let result: Fraction<Int> = Fraction<Int>(1, 1) ** exponent
        #expect(result == .one)
    }

    @Test(
        "Positive one base power predicate follows identity rule",
        arguments: [
            (Fraction<Int>(1, 1), true),
            (Fraction<Int>(2, 1), false)
        ]
    )
    internal func positiveOneBasePowerPredicateFollowsIdentityRule(
        value: Fraction<Int>,
        expected: Bool
    ) {
        let result: Bool = value.isPower(of: .one)
        #expect(result == expected)
    }
}

// MARK: - Positive Zero

extension FractionRaisableTests {
    @Test(
        "Raising to positive zero returns one",
        arguments: [
            Fraction<Int>(0, 1),
            Fraction<Int>(0, -2),
            Fraction<Int>(1, 1),
            Fraction<Int>(-1, 1),
            Fraction<Int>(2, 1),
            Fraction<Int>(3, 1),
            Fraction<Int>(-2, 1),
            Fraction<Int>(-3, 1)
        ]
    )
    internal func raisingToPositiveZeroReturnsOne(base: Fraction<Int>) {
        let result: Fraction<Int> = base ** .zero
        #expect(result == 1)
    }

    @Test(
        "Positive zero base power predicate follows rational rules",
        arguments: [
            (Fraction<Int>(0, 1), true),
            (Fraction<Int>(0, -1), true),
            (Fraction<Int>(1, 1), true),
            (Fraction<Int>(2, 1), false),
            (Fraction<Int>.infinity, true),
            (Fraction<Int>.negativeInfinity, false)
        ]
    )
    internal func positiveZeroBasePowerPredicateFollowsRationalRules(
        value: Fraction<Int>,
        expected: Bool
    ) {
        let result: Bool = value.isPower(of: .zero)
        #expect(result == expected)
    }

    @Test(
        "Positive zero base exponentiation follows rational rules",
        arguments: [
            (Fraction<Int>(0, 1), 0, Fraction<Int>(1, 1)),
            (Fraction<Int>(0, 1), 1, Fraction<Int>(0, 1)),
            (Fraction<Int>(0, 1), 2, Fraction<Int>(0, 1)),
            (Fraction<Int>(0, 1), -1, Fraction<Int>.infinity)
        ]
    )
    internal func positiveZeroBaseExponentiationFollowsRationalRules(
        base: Fraction<Int>,
        exponent: Fraction<Int>.Exponent,
        power: Fraction<Int>
    ) {
        let result: Fraction<Int> = base ** exponent
        #expect(result == power)
    }
}
