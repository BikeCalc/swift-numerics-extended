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
    internal init() {}

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
        ] as Array<(Int, Int, Bool)>
    )
    internal func isPowerOf(
        value: Int,
        other: Int,
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
        base: Int,
        exponent: Int.Exponent,
        power: Int
    ) {
        let result: Int = base ** exponent
        #expect(result == power)
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
        var result: Int = base
        result **= exponent
        #expect(result == power)
    }

    @Test(
        "Raising to succeeds",
        arguments: Self.exponentiationArguments
    )
    internal func raisingToSucceeds(
        base: Int,
        exponent: Int.Exponent,
        power: Int
    ) throws {
        let result: Int = try base.raising(to: exponent)
        #expect(result == power)
    }

    @Test(
        "Raise to succeeds",
        arguments: Self.exponentiationArguments
    )
    internal func raiseToSucceeds(
        base: Int,
        exponent: Int.Exponent,
        power: Int
    ) throws {
        var result: Int = base
        try result.raise(to: exponent)
        #expect(result == power)
    }

    @Test(
        "Squared succeeds",
        arguments: Self.squaringArguments
    )
    internal func squaredSucceeds(
        base: Int,
        power: Int
    ) {
        let result: Int = base.squared()
        #expect(result == power)
    }

    @Test(
        "Square succeeds",
        arguments: Self.squaringArguments
    )
    internal func squareSucceeds(
        base: Int,
        power: Int
    ) {
        var result: Int = base
        result.square()
        #expect(result == power)
    }

    @Test(
        "Cubed succeeds",
        arguments: Self.cubingArguments
    )
    internal func cubedSucceeds(
        base: Int,
        power: Int
    ) {
        let result: Int = base.cubed()
        #expect(result == power)
    }

    @Test(
        "Cube succeeds",
        arguments: Self.cubingArguments
    )
    internal func cubeSucceeds(
        base: Int,
        power: Int
    ) {
        var result: Int = base
        result.cube()
        #expect(result == power)
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
        ] as Array<(Int, Int.Exponent)>
    )
    internal func exponentiationIsNotCommutative(
        base: Int,
        exponent: Int.Exponent
    ) {
        let result: Int = base ** exponent
        let reversedResult: Int = exponent ** base
        #expect(result != reversedResult)
    }

    @Test(
        "Negative exponent returns positive zero",
        arguments: [
            (2, -1, 0),
            (2, -2, 0),
            (2, -3, 0)
        ] as Array<(Int, Int.Exponent, Int)>
    )
    internal func negativeExponentReturnsPositiveZero(
        base: Int,
        exponent: Int.Exponent,
        power: Int
    ) {
        let result: Int = base ** exponent
        #expect(result == power)
    }

    @Test(
        "Negative base with negative exponent returns positive zero",
        arguments: [
            (-2, -1, 0),
            (-2, -2, 0),
            (-2, -3, 0)
        ] as Array<(Int, Int.Exponent, Int)>
    )
    internal func negativeBaseWithNegativeExponentReturnsPositiveZero(
        base: Int,
        exponent: Int.Exponent,
        power: Int
    ) {
        let result: Int = base ** exponent
        #expect(result == power)
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
        ] as Array<(Int, Int)>
    )
    internal func raisingToNegativeOneFollowsIntegerRules(
        base: Int,
        power: Int
    ) {
        let result: Int = base ** -1
        #expect(result == power)
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
        ] as Array<(Int.Exponent, Int)>
    )
    internal func negativeOneBaseExponentiationFollowsParityRule(
        exponent: Int.Exponent,
        power: Int
    ) {
        let result: Int = (-1) ** exponent
        #expect(result == power)
    }

    @Test(
        "Negative one base power predicate follows signed rules",
        arguments: [
            (1, true),
            (-1, true),
            (2, false)
        ] as Array<(Int, Bool)>
    )
    internal func negativeOneBasePowerPredicateFollowsSignedRules(
        value: Int,
        expected: Bool
    ) {
        let result: Bool = value.isPower(of: -1)
        #expect(result == expected)
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
        ] as Array<Int>
    )
    internal func raisingToNegativeZeroReturnsOne(base: Int) {
        let result: Int = base ** Int.Exponent.negativeZero
        #expect(result == 1)
    }

    @Test(
        "Negative zero base power predicate follows integer rules",
        arguments: [
            (0, true),
            (-0, true),
            (1, true),
            (2, false)
        ] as Array<(Int, Bool)>
    )
    internal func negativeZeroBasePowerPredicateFollowsIntegerRules(
        value: Int,
        expected: Bool
    ) {
        let result: Bool = value.isPower(of: Int.negativeZero)
        #expect(result == expected)
    }

    @Test(
        "Negative zero base exponentiation follows integer rules",
        arguments: [
            (.negativeZero, .zero, .one),
            (.negativeZero, 1, .negativeZero),
            (.negativeZero, 2, .zero)
        ] as Array<(Int, Int.Exponent, Int)>
    )
    internal func negativeZeroBaseExponentiationFollowsIntegerRules(
        base: Int,
        exponent: Int.Exponent,
        power: Int
    ) {
        let result: Int = base ** exponent
        #expect(result == power)
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
        ] as Array<Int>
    )
    internal func raisingToPositiveOnePreservesBase(base: Int) {
        let result: Int = base ** 1
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
        ] as Array<Int.Exponent>
    )
    internal func positiveOneBaseExponentiationReturnsPositiveOne(exponent: Int.Exponent) {
        let result: Int = 1 ** exponent
        #expect(result == 1)
    }

    @Test(
        "Positive one base power predicate follows identity rule",
        arguments: [
            (1, true),
            (2, false)
        ] as Array<(Int, Bool)>
    )
    internal func positiveOneBasePowerPredicateFollowsIdentityRule(
        value: Int,
        expected: Bool
    ) {
        let result: Bool = value.isPower(of: 1)
        #expect(result == expected)
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
        ] as Array<Int>
    )
    internal func raisingToPositiveZeroReturnsOne(base: Int) {
        let result: Int = base ** Int.Exponent.zero
        #expect(result == 1)
    }

    @Test(
        "Positive zero base power predicate follows integer rules",
        arguments: [
            (0, true),
            (-0, true),
            (1, true),
            (2, false)
        ] as Array<(Int, Bool)>
    )
    internal func positiveZeroBasePowerPredicateFollowsIntegerRules(
        value: Int,
        expected: Bool
    ) {
        let result: Bool = value.isPower(of: Int.zero)
        #expect(result == expected)
    }

    @Test(
        "Positive zero base exponentiation follows integer rules",
        arguments: [
            (.zero, .zero, .one),
            (.zero, 1, .zero),
            (.zero, 2, .zero)
        ] as Array<(Int, Int.Exponent, Int)>
    )
    internal func positiveZeroBaseExponentiationFollowsIntegerRules(
        base: Int,
        exponent: Int.Exponent,
        power: Int
    ) {
        let result: Int = base ** exponent
        #expect(result == power)
    }
}
