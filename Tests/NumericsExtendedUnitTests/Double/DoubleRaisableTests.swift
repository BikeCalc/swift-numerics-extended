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
    internal init() {}

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
        ] as Array<(Double, Double, Bool)>
    )
    internal func isPowerOf(
        value: Double,
        other: Double,
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
        base: Double,
        exponent: Double.Exponent,
        power: Double
    ) {
        let result: Double = base ** exponent
        #expect(result == power)
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
        var result: Double = base
        result **= exponent
        #expect(result == power)
    }

    @Test(
        "Raising to succeeds",
        arguments: Self.exponentiationArguments
    )
    internal func raisingToSucceeds(
        base: Double,
        exponent: Double.Exponent,
        power: Double
    ) throws {
        let result: Double = try base.raising(to: exponent)
        #expect(result == power)
    }

    @Test(
        "Raise to succeeds",
        arguments: Self.exponentiationArguments
    )
    internal func raiseToSucceeds(
        base: Double,
        exponent: Double.Exponent,
        power: Double
    ) throws {
        var result: Double = base
        try result.raise(to: exponent)
        #expect(result == power)
    }

    @Test(
        "Squared succeeds",
        arguments: Self.squaringArguments
    )
    internal func squaredSucceeds(
        base: Double,
        power: Double
    ) {
        let result: Double = base.squared()
        #expect(result == power)
    }

    @Test(
        "Square succeeds",
        arguments: Self.squaringArguments
    )
    internal func squareSucceeds(
        base: Double,
        power: Double
    ) {
        var result: Double = base
        result.square()
        #expect(result == power)
    }

    @Test(
        "Cubed succeeds",
        arguments: Self.cubingArguments
    )
    internal func cubedSucceeds(
        base: Double,
        power: Double
    ) {
        let result: Double = base.cubed()
        #expect(result == power)
    }

    @Test(
        "Cube succeeds",
        arguments: Self.cubingArguments
    )
    internal func cubeSucceeds(
        base: Double,
        power: Double
    ) {
        var result: Double = base
        result.cube()
        #expect(result == power)
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
        ] as Array<(Double, Double.Exponent)>
    )
    internal func exponentiationIsNotCommutative(
        base: Double,
        exponent: Double.Exponent
    ) {
        let result: Double = base ** exponent
        let reversedResult: Double = Double(exponent) ** Double.Exponent(base)
        #expect(result != reversedResult)
    }
}

// MARK: - NaN

extension DoubleRaisableTests {
    @Test("NaN power predicate follows floating-point rules")
    internal func nanPowerPredicateFollowsFloatingPointRules() {
        let firstResult: Bool = 1.0.isPower(of: Double.nan)
        #expect(firstResult == true)
        let secondResult: Bool = 2.0.isPower(of: Double.nan)
        #expect(secondResult == false)
        let thirdResult: Bool = Double.nan.isPower(of: 2.0)
        #expect(thirdResult == false)
    }

    @Test(
        "NaN raised to nonzero exponent returns NaN",
        arguments: [
            (.nan, 1),
            (.nan, 2),
            (.nan, -1)
        ] as Array<(Double, Double.Exponent)>
    )
    internal func nanRaisedToNonzeroExponentReturnsNaN(
        base: Double,
        exponent: Double.Exponent
    ) {
        let result: Double = base ** exponent
        #expect(result.isNaN == true)
    }

    @Test("NaN raised to positive zero returns one")
    internal func nanRaisedToPositiveZeroReturnsOne() {
        let result: Double = Double.nan ** Double.Exponent.zero
        #expect(result == 1.0)
    }

    @Test("NaN raised to negative zero returns one")
    internal func nanRaisedToNegativeZeroReturnsOne() {
        let result: Double = Double.nan ** Double.Exponent.negativeZero
        #expect(result == 1.0)
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
        ] as Array<Double>
    )
    internal func raisingToNegativeZeroReturnsOne(base: Double) {
        let result: Double = base ** Double.Exponent.negativeZero
        #expect(result == 1.0)
    }

    @Test(
        "Negative infinity base power predicate follows floating-point rules",
        arguments: [
            (0.0, true),
            (-0.0, true),
            (1.0, true),
            (2.0, false),
            (.infinity, true),
            (.negativeInfinity, true)
        ] as Array<(Double, Bool)>
    )
    internal func negativeInfinityBasePowerPredicateFollowsFloatingPointRules(
        value: Double,
        expected: Bool
    ) {
        let result: Bool = value.isPower(of: Double.negativeInfinity)
        #expect(result == expected)
    }

    @Test(
        "Negative infinity exponentiation follows parity rule",
        arguments: [
            (.negativeInfinity, 0, 1.0),
            (.negativeInfinity, 1, .negativeInfinity),
            (.negativeInfinity, 2, .infinity),
            (.negativeInfinity, -1, -0.0),
            (.negativeInfinity, -2, 0.0)
        ] as Array<(Double, Double.Exponent, Double)>
    )
    internal func negativeInfinityExponentiationFollowsParityRule(
        base: Double,
        exponent: Double.Exponent,
        power: Double
    ) {
        let result: Double = base ** exponent
        #expect(result == power)
    }

    @Test(
        "Negative infinity exponentiation preserves negative zero sign",
        arguments: [
            (.negativeInfinity, -1),
            (.negativeInfinity, -3)
        ] as Array<(Double, Double.Exponent)>
    )
    internal func negativeInfinityExponentiationPreservesNegativeZeroSign(
        base: Double,
        exponent: Double.Exponent
    ) {
        let result: Double = base ** exponent
        #expect(result == Double.zero)
        #expect(result.sign == .minus)
    }
}

// MARK: - Negative One

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
        ] as Array<(Double, Double)>
    )
    internal func raisingToNegativeOneReturnsReciprocal(
        base: Double,
        power: Double
    ) {
        let result: Double = base ** -1
        #expect(result == power)
    }

    @Test(
        "Negative one base exponentiation follows parity rule",
        arguments: [
            (0, 1.0),
            (1, -1.0),
            (2, 1.0),
            (3, -1.0),
            (-2, 1.0),
            (-3, -1.0)
        ] as Array<(Double.Exponent, Double)>
    )
    internal func negativeOneBaseExponentiationFollowsParityRule(
        exponent: Double.Exponent,
        power: Double
    ) {
        let result: Double = (-1.0) ** exponent
        #expect(result == power)
    }

    @Test(
        "Negative one base power predicate follows signed rules",
        arguments: [
            (1.0, true),
            (-1.0, true),
            (2.0, false)
        ] as Array<(Double, Bool)>
    )
    internal func negativeOneBasePowerPredicateFollowsSignedRules(
        value: Double,
        expected: Bool
    ) {
        let result: Bool = value.isPower(of: -1.0)
        #expect(result == expected)
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
            (.infinity, true),
            (.negativeInfinity, true)
        ] as Array<(Double, Bool)>
    )
    internal func negativeZeroBasePowerPredicateFollowsFloatingPointRules(
        value: Double,
        expected: Bool
    ) {
        let result: Bool = value.isPower(of: .negativeZero)
        #expect(result == expected)
    }

    @Test(
        "Negative zero base exponentiation follows parity rule",
        arguments: [
            (-0.0, 0, 1.0),
            (-0.0, 1, -0.0),
            (-0.0, 2, 0.0),
            (-0.0, -1, -Double.infinity),
            (-0.0, -2, .infinity)
        ] as Array<(Double, Double.Exponent, Double)>
    )
    internal func negativeZeroBaseExponentiationFollowsParityRule(
        base: Double,
        exponent: Double.Exponent,
        power: Double
    ) {
        let result: Double = base ** exponent
        #expect(result == power)
    }

    @Test(
        "Negative zero base exponentiation preserves negative zero sign",
        arguments: [
            (-0.0, 1),
            (-0.0, 3)
        ] as Array<(Double, Double.Exponent)>
    )
    internal func negativeZeroBaseExponentiationPreservesNegativeZeroSign(
        base: Double,
        exponent: Double.Exponent
    ) {
        let result: Double = base ** exponent
        #expect(result == Double.zero)
        #expect(result.sign == .minus)
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
            (.infinity, true),
            (.negativeInfinity, false)
        ] as Array<(Double, Bool)>
    )
    internal func positiveInfinityBasePowerPredicateFollowsFloatingPointRules(
        value: Double,
        expected: Bool
    ) {
        let result: Bool = value.isPower(of: Double.infinity)
        #expect(result == expected)
    }

    @Test(
        "Positive infinity exponentiation follows reciprocal rules",
        arguments: [
            (.infinity, 0, 1.0),
            (.infinity, 1, .infinity),
            (.infinity, -1, 0.0)
        ] as Array<(Double, Double.Exponent, Double)>
    )
    internal func positiveInfinityExponentiationFollowsReciprocalRules(
        base: Double,
        exponent: Double.Exponent,
        power: Double
    ) {
        let result: Double = base ** exponent
        #expect(result == power)
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
        ] as Array<Double>
    )
    internal func raisingToPositiveOnePreservesBase(base: Double) {
        let result: Double = base ** 1
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
        ] as Array<Double.Exponent>
    )
    internal func positiveOneBaseExponentiationReturnsPositiveOne(exponent: Double.Exponent) {
        let result: Double = 1.0 ** exponent
        #expect(result == 1.0)
    }

    @Test(
        "Positive one base power predicate follows identity rule",
        arguments: [
            (1.0, true),
            (2.0, false)
        ] as Array<(Double, Bool)>
    )
    internal func positiveOneBasePowerPredicateFollowsIdentityRule(
        value: Double,
        expected: Bool
    ) {
        let result: Bool = value.isPower(of: 1.0)
        #expect(result == expected)
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
        ] as Array<Double>
    )
    internal func raisingToPositiveZeroReturnsOne(base: Double) {
        let result: Double = base ** Double.Exponent.zero
        #expect(result == 1.0)
    }

    @Test(
        "Positive zero base power predicate follows floating-point rules",
        arguments: [
            (0.0, true),
            (-0.0, true),
            (1.0, true),
            (2.0, false),
            (.infinity, true),
            (.negativeInfinity, false)
        ] as Array<(Double, Bool)>
    )
    internal func positiveZeroBasePowerPredicateFollowsFloatingPointRules(
        value: Double,
        expected: Bool
    ) {
        let result: Bool = value.isPower(of: Double.zero)
        #expect(result == expected)
    }

    @Test(
        "Positive zero base exponentiation follows floating-point rules",
        arguments: [
            (0.0, 0, 1.0),
            (0.0, 1, 0.0),
            (0.0, 2, 0.0),
            (0.0, -1, .infinity)
        ] as Array<(Double, Double.Exponent, Double)>
    )
    internal func positiveZeroBaseExponentiationFollowsFloatingPointRules(
        base: Double,
        exponent: Double.Exponent,
        power: Double
    ) {
        let result: Double = base ** exponent
        #expect(result == power)
    }
}
