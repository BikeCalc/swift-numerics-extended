// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Roman Raisable Tests")
internal struct RomanRaisableTests {
    private static let exponentiationArguments: [(Roman, Roman.Exponent, Roman)] = [
        (2, 2, 4),
        (2, 3, 8)
    ]

    private static let squaringArguments: [(Roman, Roman)] = [
        (2, 4),
        (3, 9)
    ]

    private static let cubingArguments: [(Roman, Roman)] = [
        (2, 8),
        (3, 27)
    ]

    @Test(
        "Is power of",
        arguments: [
            (4, 2, true),
            (6, 2, false),
            (8, 2, true),
            (9, 2, false)
        ] as Array<(Roman, Roman, Bool)>
    )
    internal func isPowerOf(
        value: Roman,
        other: Roman,
        result: Bool
    ) {
        #expect(value.isPower(of: other) == result)
    }

    @Test(
        "Exponentiation succeeds",
        arguments: Self.exponentiationArguments
    )
    internal func exponentiationSucceeds(
        base: Roman,
        exponent: Roman.Exponent,
        power: Roman
    ) {
        #expect(base ** exponent == power)
    }

    @Test(
        "Exponentiation equal succeeds",
        arguments: Self.exponentiationArguments
    )
    internal func exponentiationEqualSucceeds(
        base: Roman,
        exponent: Roman.Exponent,
        power: Roman
    ) {
        var runningPower: Roman = base
        runningPower **= exponent
        #expect(runningPower == power)
    }

    @Test(
        "Raising to succeeds",
        arguments: Self.exponentiationArguments
    )
    internal func raisingToSucceeds(
        base: Roman,
        exponent: Roman.Exponent,
        power: Roman
    ) {
        #expect(base.raising(to: exponent) == power)
    }

    @Test(
        "Raise to succeeds",
        arguments: Self.exponentiationArguments
    )
    internal func raiseToSucceeds(
        base: Roman,
        exponent: Roman.Exponent,
        power: Roman
    ) {
        var runningPower: Roman = base
        runningPower.raise(to: exponent)
        #expect(runningPower == power)
    }

    @Test(
        "Squared succeeds",
        arguments: Self.squaringArguments
    )
    internal func squaredSucceeds(
        base: Roman,
        power: Roman
    ) {
        #expect(base.squared() == power)
    }

    @Test(
        "Square succeeds",
        arguments: Self.squaringArguments
    )
    internal func squareSucceeds(
        base: Roman,
        power: Roman
    ) {
        var runningPower: Roman = base
        runningPower.square()
        #expect(runningPower == power)
    }

    @Test(
        "Cubed succeeds",
        arguments: Self.cubingArguments
    )
    internal func cubedSucceeds(
        base: Roman,
        power: Roman
    ) {
        #expect(base.cubed() == power)
    }

    @Test(
        "Cube succeeds",
        arguments: Self.cubingArguments
    )
    internal func cubeSucceeds(
        base: Roman,
        power: Roman
    ) {
        var runningPower: Roman = base
        runningPower.cube()
        #expect(runningPower == power)
    }
}

extension RomanRaisableTests {
    @Test(
        "Exponentiation is not commutative",
        arguments: [
            (2, 3),
            (3, 2)
        ] as Array<(Roman, Roman.Exponent)>
    )
    internal func exponentiationIsNotCommutative(
        base: Roman,
        exponent: Roman.Exponent
    ) {
        let power: Roman = base ** exponent
        let reversedPower: Roman = exponent ** base
        #expect(power != reversedPower)
    }
}

// MARK: - Positive One

extension RomanRaisableTests {
    @Test(
        "Raising to positive one preserves base",
        arguments: [
            0,
            1,
            2,
            3
        ] as Array<Roman>
    )
    internal func raisingToPositiveOnePreservesBase(base: Roman) {
        #expect(base ** 1 == base)
    }

    @Test(
        "Positive one base exponentiation returns positive one",
        arguments: [
            0,
            1,
            2,
            3
        ] as Array<Roman.Exponent>
    )
    internal func positiveOneBaseExponentiationReturnsPositiveOne(exponent: Roman.Exponent) {
        #expect(Roman(1) ** exponent == 1)
    }

    @Test(
        "Positive one base power predicate follows identity rule",
        arguments: [
            (1, true),
            (2, false)
        ] as Array<(Roman, Bool)>
    )
    internal func positiveOneBasePowerPredicateFollowsIdentityRule(
        value: Roman,
        result: Bool
    ) {
        #expect(value.isPower(of: 1) == result)
    }
}

// MARK: - Positive Zero

extension RomanRaisableTests {
    @Test(
        "Raising to positive zero returns one",
        arguments: [
            0,
            1,
            2,
            3
        ] as Array<Roman>
    )
    internal func raisingToPositiveZeroReturnsOne(base: Roman) {
        #expect(base ** Roman.Exponent.zero == 1)
    }

    @Test(
        "Positive zero base power predicate follows unsigned integer rules",
        arguments: [
            (0, true),
            (1, true),
            (2, false)
        ] as Array<(Roman, Bool)>
    )
    internal func positiveZeroBasePowerPredicateFollowsIntegerRules(
        value: Roman,
        result: Bool
    ) {
        #expect(value.isPower(of: Roman.zero) == result)
    }

    @Test(
        "Positive zero base exponentiation follows unsigned integer rules",
        arguments: [
            (0, 0, 1),
            (0, 1, 0),
            (0, 2, 0)
        ] as Array<(Roman, Roman.Exponent, Roman)>
    )
    internal func positiveZeroBaseExponentiationFollowsIntegerRules(
        base: Roman,
        exponent: Roman.Exponent,
        power: Roman
    ) {
        #expect(base ** exponent == power)
    }
}
