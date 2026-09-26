// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Int Raisable Tests")
internal struct IntRaisableTests {
    private static let exponentiationArguments: [(Int, Int.Exponent, Int)] = [
        (2, 2, 4),
        (2, 3, 8),
        (2, -2, 0),
        (2, -3, 0),
        (-2, 2, 4),
        (-2, 3, -8),
        (-2, -2, 0),
        (-2, -3, 0),
        (1, -2, 1),
        (1, -3, 1),
        (-1, -2, 1),
        (-1, -3, -1)
    ]

    private static let squaringArguments: [(Int, Int)] = [
        (2, 4),
        (3, 9),
        (-2, 4),
        (-3, 9)
    ]

    private static let cubingArguments: [(Int, Int)] = [
        (2, 8),
        (3, 27),
        (-2, -8),
        (-3, -27)
    ]

    @Test(
        "Is power of",
        arguments: [
            (4, 2, true),
            (6, 2, false),
            (8, 2, true),
            (9, 2, false),
            (4, -2, true),
            (-8, -2, true),
            (6, -2, false)
        ]
    )
    internal func isPowerOf(
        value: Int,
        other: Int,
        result: Bool
    ) {
        #expect(value.isPower(of: other) == result)
    }

    @Test(
        "Exponentiation succeeds",
        arguments: Self.exponentiationArguments
    )
    internal func exponentiationSucceeds(
        base: Int,
        exponent: Int.Exponent,
        power: Int
    ) {
        #expect(base ** exponent == power)
    }

    @Test(
        "Exponentiation equal succeeds",
        arguments: Self.exponentiationArguments
    )
    internal func exponentiationEqualSucceeds(
        base: Int,
        exponent: Int.Exponent,
        power: Int
    ) {
        var runningPower: Int = base
        runningPower **= exponent
        #expect(runningPower == power)
    }

    @Test(
        "Raising to succeeds",
        arguments: Self.exponentiationArguments
    )
    internal func raisingToSucceeds(
        base: Int,
        exponent: Int.Exponent,
        power: Int
    ) {
        #expect(base.raising(to: exponent) == power)
    }

    @Test(
        "Raise to succeeds",
        arguments: Self.exponentiationArguments
    )
    internal func raiseToSucceeds(
        base: Int,
        exponent: Int.Exponent,
        power: Int
    ) {
        var runningPower: Int = base
        runningPower.raise(to: exponent)
        #expect(runningPower == power)
    }

    @Test(
        "Squared succeeds",
        arguments: Self.squaringArguments
    )
    internal func squaredSucceeds(
        base: Int,
        power: Int
    ) {
        #expect(base.squared() == power)
    }

    @Test(
        "Square succeeds",
        arguments: Self.squaringArguments
    )
    internal func squareSucceeds(
        base: Int,
        power: Int
    ) {
        var runningPower: Int = base
        runningPower.square()
        #expect(runningPower == power)
    }

    @Test(
        "Cubed succeeds",
        arguments: Self.cubingArguments
    )
    internal func cubedSucceeds(
        base: Int,
        power: Int
    ) {
        #expect(base.cubed() == power)
    }

    @Test(
        "Cube succeeds",
        arguments: Self.cubingArguments
    )
    internal func cubeSucceeds(
        base: Int,
        power: Int
    ) {
        var runningPower: Int = base
        runningPower.cube()
        #expect(runningPower == power)
    }
}

extension IntRaisableTests {
    @Test(
        "Exponentiation is not commutative",
        arguments: [
            (2, 3),
            (3, 2),
            (-2, 3),
            (2, -2)
        ]
    )
    internal func exponentiationIsNotCommutative(
        base: Int,
        exponent: Int.Exponent
    ) {
        let power: Int = base ** exponent
        let reversedPower: Int = exponent ** base
        #expect(power != reversedPower)
    }

    @Test(
        "Negative exponent returns positive zero",
        arguments: [
            (2, -1, 0),
            (2, -2, 0),
            (2, -3, 0)
        ]
    )
    internal func negativeExponentReturnsPositiveZero(
        base: Int,
        exponent: Int.Exponent,
        power: Int
    ) {
        #expect(base ** exponent == power)
    }

    @Test(
        "Negative base with negative exponent returns positive zero",
        arguments: [
            (-2, -1, 0),
            (-2, -2, 0),
            (-2, -3, 0)
        ]
    )
    internal func negativeBaseWithNegativeExponentReturnsPositiveZero(
        base: Int,
        exponent: Int.Exponent,
        power: Int
    ) {
        #expect(base ** exponent == power)
    }
}

// MARK: - Negative One

extension IntRaisableTests {
    @Test(
        "Raising to negative one follows integer rules",
        arguments: [
            (1, 1),
            (-1, -1),
            (2, 0),
            (-2, 0)
        ]
    )
    internal func raisingToNegativeOneFollowsIntegerRules(
        base: Int,
        power: Int
    ) {
        #expect(base ** -1 == power)
    }

    @Test(
        "Negative one base exponentiation follows parity rule",
        arguments: [
            (0, 1),
            (1, -1),
            (2, 1),
            (3, -1),
            (-2, 1),
            (-3, -1)
        ]
    )
    internal func negativeOneBaseExponentiationFollowsParityRule(
        exponent: Int.Exponent,
        power: Int
    ) {
        #expect((-1) ** exponent == power)
    }

    @Test(
        "Negative one base power predicate follows signed rules",
        arguments: [
            (1, true),
            (-1, true),
            (2, false)
        ]
    )
    internal func negativeOneBasePowerPredicateFollowsSignedRules(
        value: Int,
        result: Bool
    ) {
        #expect(value.isPower(of: -1) == result)
    }
}

// MARK: - Negative Zero

extension IntRaisableTests {
    @Test(
        "Raising to negative zero returns one",
        arguments: [
            0,
            -0,
            1,
            -1,
            2,
            3,
            -2,
            -3
        ]
    )
    internal func raisingToNegativeZeroReturnsOne(base: Int) {
        #expect(base ** Int.Exponent.negativeZero == 1)
    }

    @Test(
        "Negative zero base power predicate follows integer rules",
        arguments: [
            (0, true),
            (-0, true),
            (1, true),
            (2, false)
        ]
    )
    internal func negativeZeroBasePowerPredicateFollowsIntegerRules(
        value: Int,
        result: Bool
    ) {
        #expect(value.isPower(of: Int.negativeZero) == result)
    }

    @Test(
        "Negative zero base exponentiation follows integer rules",
        arguments: [
            (Int.negativeZero, Int.Exponent.zero, Int.one),
            (Int.negativeZero, 1, Int.negativeZero),
            (Int.negativeZero, 2, Int.zero)
        ]
    )
    internal func negativeZeroBaseExponentiationFollowsIntegerRules(
        base: Int,
        exponent: Int.Exponent,
        power: Int
    ) {
        #expect(base ** exponent == power)
    }
}

// MARK: - Positive One

extension IntRaisableTests {
    @Test(
        "Raising to positive one preserves base",
        arguments: [
            0,
            -0,
            1,
            -1,
            2,
            3,
            -2,
            -3
        ]
    )
    internal func raisingToPositiveOnePreservesBase(base: Int) {
        #expect(base ** 1 == base)
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
    internal func positiveOneBaseExponentiationReturnsPositiveOne(exponent: Int.Exponent) {
        #expect(1 ** exponent == 1)
    }

    @Test(
        "Positive one base power predicate follows identity rule",
        arguments: [
            (1, true),
            (2, false)
        ]
    )
    internal func positiveOneBasePowerPredicateFollowsIdentityRule(
        value: Int,
        result: Bool
    ) {
        #expect(value.isPower(of: 1) == result)
    }
}

// MARK: - Positive Zero

extension IntRaisableTests {
    @Test(
        "Raising to positive zero returns one",
        arguments: [
            0,
            -0,
            1,
            -1,
            2,
            3,
            -2,
            -3
        ]
    )
    internal func raisingToPositiveZeroReturnsOne(base: Int) {
        #expect(base ** Int.Exponent.zero == 1)
    }

    @Test(
        "Positive zero base power predicate follows integer rules",
        arguments: [
            (0, true),
            (-0, true),
            (1, true),
            (2, false)
        ]
    )
    internal func positiveZeroBasePowerPredicateFollowsIntegerRules(
        value: Int,
        result: Bool
    ) {
        #expect(value.isPower(of: Int.zero) == result)
    }

    @Test(
        "Positive zero base exponentiation follows integer rules",
        arguments: [
            (Int.zero, Int.Exponent.zero, Int.one),
            (Int.zero, 1, Int.zero),
            (Int.zero, 2, Int.zero)
        ]
    )
    internal func positiveZeroBaseExponentiationFollowsIntegerRules(
        base: Int,
        exponent: Int.Exponent,
        power: Int
    ) {
        #expect(base ** exponent == power)
    }
}
