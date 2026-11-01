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
        (.init(2, 3), 2, .init(4, 9)),
        (.init(2, 3), 3, .init(8, 27)),
        (.init(2, 3), -2, .init(9, 4)),
        (.init(2, 3), -3, .init(27, 8)),
        (.init(-2, 3), 2, .init(4, 9)),
        (.init(-2, 3), 3, .init(-8, 27)),
        (.init(-2, 3), -2, .init(9, 4)),
        (.init(-2, 3), -3, .init(27, -8)),
        (.init(1, 1), -2, .init(1, 1)),
        (.init(1, 1), -3, .init(1, 1)),
        (.init(-1, 1), -2, .init(1, 1)),
        (.init(-1, 1), -3, .init(1, -1))
    ]

    private static let squaringArguments: [(Fraction<Int>, Fraction<Int>)] = [
        (.init(2, 3), .init(4, 9)),
        (.init(3, 4), .init(9, 16)),
        (.init(-2, 3), .init(4, 9)),
        (.init(-3, 4), .init(9, 16))
    ]

    private static let cubingArguments: [(Fraction<Int>, Fraction<Int>)] = [
        (.init(2, 3), .init(8, 27)),
        (.init(3, 4), .init(27, 64)),
        (.init(-2, 3), .init(-8, 27)),
        (.init(-3, 4), .init(-27, 64))
    ]

    @Test(
        "Is power of",
        arguments: [
            (.init(4, 1), .init(2, 1), true),
            (.init(6, 1), .init(2, 1), false),
            (.init(8, 1), .init(2, 1), true),
            (.init(9, 1), .init(2, 1), false),
            (.init(4, 1), .init(-2, 1), true),
            (.init(-8, 1), .init(-2, 1), true),
            (.init(6, 1), .init(-2, 1), false),
            (.init(1, 4), .init(2, 1), true),
            (.init(4, 1), .init(1, 2), true),
            (.init(-1, 8), .init(-2, 1), true),
            (.init(1, 8), .init(-2, 1), false)
        ] as Array<(Fraction<Int>, Fraction<Int>, Bool)>
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
            (.init(2, 1), 3),
            (.init(3, 1), 2),
            (.init(-2, 1), 3),
            (.init(2, 1), -2)
        ] as Array<(Fraction<Int>, Fraction<Int>.Exponent)>
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
            (.init(1, 1), .init(1, 1)),
            (.init(-1, 1), .init(1, -1)),
            (.init(2, 3), .init(3, 2)),
            (.init(-2, 3), .init(3, -2))
        ] as Array<(Fraction<Int>, Fraction<Int>)>
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
            (.nan, 1),
            (.nan, 2),
            (.nan, -1)
        ] as Array<(Fraction<Int>, Fraction<Int>.Exponent)>
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
            .init(0, 1),
            .init(0, -2),
            .init(1, 1),
            .init(-1, 1),
            .init(2, 1),
            .init(3, 1),
            .init(-2, 1),
            .init(-3, 1)
        ] as Array<Fraction<Int>>
    )
    internal func raisingToNegativeZeroReturnsOne(base: Fraction<Int>) {
        let result: Fraction<Int> = base ** Fraction<Int>.Exponent.negativeZero
        #expect(result == 1)
    }

    @Test(
        "Negative infinity base power predicate follows rational rules",
        arguments: [
            (.init(0, 1), true),
            (.init(0, -1), true),
            (.init(1, 1), true),
            (.init(2, 1), false),
            (.infinity, true),
            (.negativeInfinity, true)
        ] as Array<(Fraction<Int>, Bool)>
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
            (.negativeInfinity, 0, .init(1, 1)),
            (.negativeInfinity, 1, .negativeInfinity),
            (.negativeInfinity, 2, .infinity),
            (.negativeInfinity, -1, .init(0, -1)),
            (.negativeInfinity, -2, .init(0, 1))
        ] as Array<(Fraction<Int>, Fraction<Int>.Exponent, Fraction<Int>)>
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
            (0, .init(1, 1)),
            (1, .init(-1, 1)),
            (2, .init(1, 1)),
            (3, .init(-1, 1)),
            (-2, .init(1, 1)),
            (-3, .init(1, -1))
        ] as Array<(Fraction<Int>.Exponent, Fraction<Int>)>
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
            (.init(1, 1), true),
            (.init(-1, 1), true),
            (.init(2, 1), false)
        ] as Array<(Fraction<Int>, Bool)>
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
            (.init(0, 1), true),
            (.init(0, -1), true),
            (.init(1, 1), true),
            (.init(2, 1), false),
            (.infinity, true),
            (.negativeInfinity, true)
        ] as Array<(Fraction<Int>, Bool)>
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
            (.init(0, -1), 0, .init(1, 1)),
            (.init(0, -1), 1, .init(0, -1)),
            (.init(0, -1), 2, .init(0, 1)),
            (.init(0, -1), -1, .negativeInfinity),
            (.init(0, -1), -2, .infinity)
        ] as Array<(Fraction<Int>, Fraction<Int>.Exponent, Fraction<Int>)>
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
            (.init(0, 1), true),
            (.init(0, -1), true),
            (.init(1, 1), true),
            (.init(2, 1), false),
            (.infinity, true),
            (.negativeInfinity, false)
        ] as Array<(Fraction<Int>, Bool)>
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
            (.infinity, 0, .init(1, 1)),
            (.infinity, 1, .infinity),
            (.infinity, -1, .init(0, 1))
        ] as Array<(Fraction<Int>, Fraction<Int>.Exponent, Fraction<Int>)>
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
            .init(0, 1),
            .init(0, -2),
            .init(1, 1),
            .init(-1, 1),
            .init(2, 1),
            .init(3, 1),
            .init(-2, 1),
            .init(-3, 1)
        ] as Array<Fraction<Int>>
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
        ] as Array<Fraction<Int>.Exponent>
    )
    internal func positiveOneBaseExponentiationReturnsPositiveOne(exponent: Fraction<Int>.Exponent) {
        let result: Fraction<Int> = Fraction<Int>(1, 1) ** exponent
        #expect(result == .one)
    }

    @Test(
        "Positive one base power predicate follows identity rule",
        arguments: [
            (.init(1, 1), true),
            (.init(2, 1), false)
        ] as Array<(Fraction<Int>, Bool)>
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
            .init(0, 1),
            .init(0, -2),
            .init(1, 1),
            .init(-1, 1),
            .init(2, 1),
            .init(3, 1),
            .init(-2, 1),
            .init(-3, 1)
        ] as Array<Fraction<Int>>
    )
    internal func raisingToPositiveZeroReturnsOne(base: Fraction<Int>) {
        let result: Fraction<Int> = base ** .zero
        #expect(result == 1)
    }

    @Test(
        "Positive zero base power predicate follows rational rules",
        arguments: [
            (.init(0, 1), true),
            (.init(0, -1), true),
            (.init(1, 1), true),
            (.init(2, 1), false),
            (.infinity, true),
            (.negativeInfinity, false)
        ] as Array<(Fraction<Int>, Bool)>
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
            (.init(0, 1), 0, .init(1, 1)),
            (.init(0, 1), 1, .init(0, 1)),
            (.init(0, 1), 2, .init(0, 1)),
            (.init(0, 1), -1, .infinity)
        ] as Array<(Fraction<Int>, Fraction<Int>.Exponent, Fraction<Int>)>
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
