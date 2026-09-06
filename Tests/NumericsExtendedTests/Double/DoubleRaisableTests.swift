// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Double Raisable Tests")
internal struct DoubleRaisableTests {
    private static let exponentiationArguments: [(Double, Double.Exponent, Double)] = [
        (2.0, 2, 4.0),
        (2.0, 3, 8.0),
        (2.0, -2, 0.25),
        (2.0, -3, 0.125),
        (-2.0, 2, 4.0),
        (-2.0, 3, -8.0),
        (-2.0, -2, 0.25),
        (-2.0, -3, -0.125),
        (1.0, -2, 1.0),
        (1.0, -3, 1.0),
        (-1.0, -2, 1.0),
        (-1.0, -3, -1.0),
        (0.5, 2, 0.25),
        (0.5, 3, 0.125),
        (0.5, -2, 4.0),
        (0.5, -3, 8.0),
        (-0.5, 2, 0.25),
        (-0.5, 3, -0.125),
        (-0.5, -2, 4.0),
        (-0.5, -3, -8.0)
    ]

    private static let squaringArguments: [(Double, Double)] = [
        (2.0, 4.0),
        (3.0, 9.0),
        (-2.0, 4.0),
        (-3.0, 9.0),
        (0.5, 0.25),
        (1.5, 2.25),
        (-0.5, 0.25),
        (-1.5, 2.25)
    ]

    private static let cubingArguments: [(Double, Double)] = [
        (2.0, 8.0),
        (3.0, 27.0),
        (-2.0, -8.0),
        (-3.0, -27.0),
        (0.5, 0.125),
        (1.5, 3.375),
        (-0.5, -0.125),
        (-1.5, -3.375)
    ]

    @Test(
        "Is power of",
        arguments: [
            (4.0, 2.0, true),
            (6.0, 2.0, false),
            (8.0, 2.0, true),
            (9.0, 2.0, false),
            (4.0, -2.0, true),
            (-8.0, -2.0, true),
            (6.0, -2.0, false),
            (0.25, 2.0, true),
            (4.0, 0.5, true),
            (-0.125, -2.0, true),
            (0.2, 2.0, false)
        ]
    )
    internal func isPowerOf(
        value: Double,
        other: Double,
        result: Bool
    ) {
        #expect(value.isPower(of: other) == result)
    }

    @Test(
        "Exponentiation succeeds",
        arguments: Self.exponentiationArguments
    )
    internal func exponentiationSucceeds(
        base: Double,
        exponent: Double.Exponent,
        power: Double
    ) {
        #expect(base ** exponent == power)
    }

    @Test(
        "Exponentiation equal succeeds",
        arguments: Self.exponentiationArguments
    )
    internal func exponentiationEqualSucceeds(
        base: Double,
        exponent: Double.Exponent,
        power: Double
    ) {
        var runningPower: Double = base
        runningPower **= exponent
        #expect(runningPower == power)
    }

    @Test(
        "Raising to succeeds",
        arguments: Self.exponentiationArguments
    )
    internal func raisingToSucceeds(
        base: Double,
        exponent: Double.Exponent,
        power: Double
    ) {
        #expect(base.raising(to: exponent) == power)
    }

    @Test(
        "Raise to succeeds",
        arguments: Self.exponentiationArguments
    )
    internal func raiseToSucceeds(
        base: Double,
        exponent: Double.Exponent,
        power: Double
    ) {
        var runningPower: Double = base
        runningPower.raise(to: exponent)
        #expect(runningPower == power)
    }

    @Test(
        "Squared succeeds",
        arguments: Self.squaringArguments
    )
    internal func squaredSucceeds(
        base: Double,
        power: Double
    ) {
        #expect(base.squared() == power)
    }

    @Test(
        "Square succeeds",
        arguments: Self.squaringArguments
    )
    internal func squareSucceeds(
        base: Double,
        power: Double
    ) {
        var runningPower: Double = base
        runningPower.square()
        #expect(runningPower == power)
    }

    @Test(
        "Cubed succeeds",
        arguments: Self.cubingArguments
    )
    internal func cubedSucceeds(
        base: Double,
        power: Double
    ) {
        #expect(base.cubed() == power)
    }

    @Test(
        "Cube succeeds",
        arguments: Self.cubingArguments
    )
    internal func cubeSucceeds(
        base: Double,
        power: Double
    ) {
        var runningPower: Double = base
        runningPower.cube()
        #expect(runningPower == power)
    }
}

extension DoubleRaisableTests {
    @Test(
        "Exponentiation is not commutative",
        arguments: [
            (2.0, 3),
            (3.0, 2),
            (-2.0, 3),
            (0.5, 2),
            (2.0, -2)
        ]
    )
    internal func exponentiationIsNotCommutative(
        base: Double,
        exponent: Double.Exponent
    ) {
        let power: Double = base ** exponent
        let reversedPower: Double = Double(exponent) ** Double.Exponent(base)
        #expect(power != reversedPower)
    }
}

// MARK: - NaN

extension DoubleRaisableTests {
    @Test(
        "Raising to negative one returns reciprocal",
        arguments: [
            (1.0, 1.0),
            (-1.0, -1.0),
            (2.0, 0.5),
            (-2.0, -0.5),
            (0.5, 2.0),
            (-0.5, -2.0)
        ]
    )
    internal func raisingToNegativeOneReturnsReciprocal(
        base: Double,
        power: Double
    ) {
        #expect(base ** -1 == power)
    }

    @Test("NaN power predicate follows floating-point rules")
    internal func nanPowerPredicateFollowsFloatingPointRules() {
        #expect(1.0.isPower(of: Double.nan) == true)
        #expect(2.0.isPower(of: Double.nan) == false)
        #expect(Double.nan.isPower(of: 2.0) == false)
    }

    @Test(
        "NaN raised to nonzero exponent returns NaN",
        arguments: [
            (Double.nan, 1),
            (Double.nan, 2),
            (Double.nan, -1)
        ]
    )
    internal func nanRaisedToNonzeroExponentReturnsNaN(
        base: Double,
        exponent: Double.Exponent
    ) {
        #expect((base ** exponent).isNaN == true)
    }

    @Test("NaN raised to positive zero returns one")
    internal func nanRaisedToPositiveZeroReturnsOne() {
        let power: Double = Double.nan ** Double.Exponent.zero

        #expect(power == 1.0)
    }

    @Test("NaN raised to negative zero returns one")
    internal func nanRaisedToNegativeZeroReturnsOne() {
        let power: Double = Double.nan ** Double.Exponent.negativeZero

        #expect(power == 1.0)
    }
}

// MARK: - Negative Infinity

extension DoubleRaisableTests {
    @Test(
        "Raising to negative zero returns one",
        arguments: [
            0.0,
            -0.0,
            1.0,
            -1.0,
            2.0,
            3.0,
            -2.0,
            -3.0,
            0.5,
            1.5,
            -0.5,
            -1.5
        ]
    )
    internal func raisingToNegativeZeroReturnsOne(base: Double) {
        #expect(base ** Double.Exponent.negativeZero == 1.0)
    }

    @Test(
        "Negative infinity base power predicate follows floating-point rules",
        arguments: [
            (0.0, true),
            (-0.0, true),
            (1.0, true),
            (2.0, false),
            (Double.infinity, true),
            (Double.negativeInfinity, true)
        ]
    )
    internal func negativeInfinityBasePowerPredicateFollowsFloatingPointRules(
        value: Double,
        result: Bool
    ) {
        #expect(value.isPower(of: Double.negativeInfinity) == result)
    }

    @Test(
        "Negative infinity exponentiation follows parity rule",
        arguments: [
            (Double.negativeInfinity, 0, 1.0),
            (Double.negativeInfinity, 1, Double.negativeInfinity),
            (Double.negativeInfinity, 2, Double.infinity),
            (Double.negativeInfinity, -1, -0.0),
            (Double.negativeInfinity, -2, 0.0)
        ]
    )
    internal func negativeInfinityExponentiationFollowsParityRule(
        base: Double,
        exponent: Double.Exponent,
        power: Double
    ) {
        #expect(base ** exponent == power)
    }

    @Test(
        "Negative infinity exponentiation preserves negative zero sign",
        arguments: [
            (Double.negativeInfinity, -1),
            (Double.negativeInfinity, -3)
        ]
    )
    internal func negativeInfinityExponentiationPreservesNegativeZeroSign(
        base: Double,
        exponent: Double.Exponent
    ) {
        let power: Double = base ** exponent

        #expect(power == Double.zero)
        #expect(power.sign == .minus)
    }
}

// MARK: - Negative One

extension DoubleRaisableTests {
    @Test(
        "Negative one base exponentiation follows parity rule",
        arguments: [
            (0, 1.0),
            (1, -1.0),
            (2, 1.0),
            (3, -1.0),
            (-2, 1.0),
            (-3, -1.0)
        ]
    )
    internal func negativeOneBaseExponentiationFollowsParityRule(
        exponent: Double.Exponent,
        power: Double
    ) {
        #expect((-1.0) ** exponent == power)
    }

    @Test(
        "Negative one base power predicate follows signed rules",
        arguments: [
            (1.0, true),
            (-1.0, true),
            (2.0, false)
        ]
    )
    internal func negativeOneBasePowerPredicateFollowsSignedRules(
        value: Double,
        result: Bool
    ) {
        #expect(value.isPower(of: -1.0) == result)
    }
}

// MARK: - Negative Zero

extension DoubleRaisableTests {
    @Test(
        "Negative zero base power predicate follows floating-point rules",
        arguments: [
            (0.0, true),
            (-0.0, true),
            (1.0, true),
            (2.0, false),
            (Double.infinity, true),
            (Double.negativeInfinity, true)
        ]
    )
    internal func negativeZeroBasePowerPredicateFollowsFloatingPointRules(
        value: Double,
        result: Bool
    ) {
        #expect(value.isPower(of: .negativeZero) == result)
    }

    @Test(
        "Negative zero base exponentiation follows parity rule",
        arguments: [
            (-0.0, 0, 1.0),
            (-0.0, 1, -0.0),
            (-0.0, 2, 0.0),
            (-0.0, -1, -Double.infinity),
            (-0.0, -2, Double.infinity)
        ]
    )
    internal func negativeZeroBaseExponentiationFollowsParityRule(
        base: Double,
        exponent: Double.Exponent,
        power: Double
    ) {
        #expect(base ** exponent == power)
    }

    @Test(
        "Negative zero base exponentiation preserves negative zero sign",
        arguments: [
            (-0.0, 1),
            (-0.0, 3)
        ]
    )
    internal func negativeZeroBaseExponentiationPreservesNegativeZeroSign(
        base: Double,
        exponent: Double.Exponent
    ) {
        let power: Double = base ** exponent

        #expect(power == Double.zero)
        #expect(power.sign == .minus)
    }
}

// MARK: - Positive Infinity

extension DoubleRaisableTests {
    @Test(
        "Positive infinity base power predicate follows floating-point rules",
        arguments: [
            (0.0, true),
            (-0.0, true),
            (1.0, true),
            (2.0, false),
            (Double.infinity, true),
            (Double.negativeInfinity, false)
        ]
    )
    internal func positiveInfinityBasePowerPredicateFollowsFloatingPointRules(
        value: Double,
        result: Bool
    ) {
        #expect(value.isPower(of: Double.infinity) == result)
    }

    @Test(
        "Positive infinity exponentiation follows reciprocal rules",
        arguments: [
            (Double.infinity, 0, 1.0),
            (Double.infinity, 1, Double.infinity),
            (Double.infinity, -1, 0.0)
        ]
    )
    internal func positiveInfinityExponentiationFollowsReciprocalRules(
        base: Double,
        exponent: Double.Exponent,
        power: Double
    ) {
        #expect(base ** exponent == power)
    }
}

// MARK: - Positive One

extension DoubleRaisableTests {
    @Test(
        "Raising to positive one preserves base",
        arguments: [
            0.0,
            -0.0,
            1.0,
            -1.0,
            2.0,
            3.0,
            -2.0,
            -3.0,
            0.5,
            1.5,
            -0.5,
            -1.5
        ]
    )
    internal func raisingToPositiveOnePreservesBase(base: Double) {
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
    internal func positiveOneBaseExponentiationReturnsPositiveOne(exponent: Double.Exponent) {
        #expect(1.0 ** exponent == 1.0)
    }

    @Test(
        "Positive one base power predicate follows identity rule",
        arguments: [
            (1.0, true),
            (2.0, false)
        ]
    )
    internal func positiveOneBasePowerPredicateFollowsIdentityRule(
        value: Double,
        result: Bool
    ) {
        #expect(value.isPower(of: 1.0) == result)
    }
}

// MARK: - Positive Zero

extension DoubleRaisableTests {
    @Test(
        "Raising to positive zero returns one",
        arguments: [
            0.0,
            -0.0,
            1.0,
            -1.0,
            2.0,
            3.0,
            -2.0,
            -3.0,
            0.5,
            1.5,
            -0.5,
            -1.5
        ]
    )
    internal func raisingToPositiveZeroReturnsOne(base: Double) {
        #expect(base ** Double.Exponent.zero == 1.0)
    }

    @Test(
        "Positive zero base power predicate follows floating-point rules",
        arguments: [
            (0.0, true),
            (-0.0, true),
            (1.0, true),
            (2.0, false),
            (Double.infinity, true),
            (Double.negativeInfinity, false)
        ]
    )
    internal func positiveZeroBasePowerPredicateFollowsFloatingPointRules(
        value: Double,
        result: Bool
    ) {
        #expect(value.isPower(of: Double.zero) == result)
    }

    @Test(
        "Positive zero base exponentiation follows floating-point rules",
        arguments: [
            (0.0, 0, 1.0),
            (0.0, 1, 0.0),
            (0.0, 2, 0.0),
            (0.0, -1, Double.infinity)
        ]
    )
    internal func positiveZeroBaseExponentiationFollowsFloatingPointRules(
        base: Double,
        exponent: Double.Exponent,
        power: Double
    ) {
        #expect(base ** exponent == power)
    }
}
