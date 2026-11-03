// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Double Divisible Tests")
internal struct DoubleDivisibleTests {
    internal init() {}

    private static let divisionArguments: [(Double, Double.Divisor, Double)] = [
        (6.0, 2.0, 3.0),
        (6.0, 3.0, 2.0),
        (-6.0, 2.0, -3.0),
        (-6.0, -3.0, 2.0),
        (1.5, 0.5, 3.0),
        (3.75, 1.5, 2.5),
        (-1.5, 0.5, -3.0),
        (-3.75, -1.5, 2.5)
    ]

    private static let remainderArguments: [(Double, Double.RemainderDivisor, Double)] = [
        (4.0, 2.0, 0.0),
        (5.0, 2.0, 1.0),
        (5.0, -2.0, 1.0),
        (-5.0, 2.0, -1.0),
        (-5.0, -2.0, -1.0),
        (1.5, 0.5, 0.0),
        (1.75, 0.5, 0.25),
        (-1.75, 0.5, -0.25),
        (-1.75, -0.5, -0.25)
    ]

    private static let halvingArguments: [(Double, Double)] = [
        (6.0, 3.0),
        (4.0, 2.0),
        (-6.0, -3.0),
        (-4.0, -2.0),
        (1.5, 0.75),
        (3.75, 1.875),
        (-1.5, -0.75),
        (-3.75, -1.875)
    ]

    @Test(
        "Reciprocal",
        arguments: [
            (2.0, 0.5),
            (4.0, 0.25),
            (-2.0, -0.5),
            (-4.0, -0.25),
            (0.5, 2.0),
            (0.25, 4.0),
            (-0.5, -2.0),
            (-0.25, -4.0)
        ] as Array<(Double, Double.Reciprocal?)>
    )
    internal func reciprocal(
        dividend: Double,
        expected: Double.Reciprocal?
    ) {
        #expect(dividend.reciprocal == expected)
    }

    @Test(
        "Is invertible",
        arguments: [
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
    internal func isInvertible(dividend: Double) {
        #expect(dividend.isInvertible == true)
    }

    @Test(
        "Is divisible by",
        arguments: [
            (6.0, 3.0, true),
            (7.0, 3.0, false),
            (-6.0, 3.0, true),
            (-7.0, 3.0, false),
            (1.5, 0.5, true),
            (1.5, 2.5, false),
            (-1.5, 0.5, true),
            (-1.5, 2.5, false)
        ] as Array<(Double, Double, Bool)>
    )
    internal func isDivisibleBy(
        dividend: Double,
        divisor: Double,
        expected: Bool
    ) {
        let result: Bool = dividend.isDivisible(by: divisor)
        #expect(result == expected)
    }

    @Test(
        "Is factor of",
        arguments: [
            (3.0, 6.0, true),
            (3.0, 7.0, false),
            (3.0, -6.0, true),
            (3.0, -7.0, false),
            (0.5, 1.5, true),
            (2.5, 1.5, false),
            (0.5, -1.5, true),
            (2.5, -1.5, false)
        ] as Array<(Double, Double, Bool)>
    )
    internal func isFactorOf(
        factor: Double,
        value: Double,
        expected: Bool
    ) {
        let result: Bool = factor.isFactor(of: value)
        #expect(result == expected)
    }

    @Test(
        "Division succeeds",
        arguments: Self.divisionArguments
    )
    internal func divisionSucceeds(
        dividend: Double,
        divisor: Double.Divisor,
        quotient: Double
    ) {
        let result: Double = dividend / divisor
        #expect(result == quotient)
    }

    @Test(
        "Division equal succeeds",
        arguments: Self.divisionArguments
    )
    internal func divisionEqualSucceeds(
        dividend: Double,
        divisor: Double.Divisor,
        quotient: Double
    ) {
        var result: Double = dividend
        result /= divisor
        #expect(result == quotient)
    }

    @Test(
        "Remainder succeeds",
        arguments: Self.remainderArguments
    )
    internal func remainderSucceeds(
        dividend: Double,
        divisor: Double.RemainderDivisor,
        remainder: Double
    ) {
        let result: Double = dividend % divisor
        #expect(result == remainder)
    }

    @Test(
        "Remainder equal succeeds",
        arguments: Self.remainderArguments
    )
    internal func remainderEqualSucceeds(
        dividend: Double,
        divisor: Double.RemainderDivisor,
        remainder: Double
    ) {
        var result: Double = dividend
        result %= divisor
        #expect(result == remainder)
    }

    @Test(
        "Dividing by succeeds",
        arguments: Self.divisionArguments
    )
    internal func dividingBySucceeds(
        dividend: Double,
        divisor: Double.Divisor,
        quotient: Double
    ) throws {
        let result: Double = try dividend.dividing(by: divisor)
        #expect(result == quotient)
    }

    @Test(
        "Divide by succeeds",
        arguments: Self.divisionArguments
    )
    internal func divideBySucceeds(
        dividend: Double,
        divisor: Double.Divisor,
        quotient: Double
    ) throws {
        var result: Double = dividend
        try result.divide(by: divisor)
        #expect(result == quotient)
    }

    @Test(
        "Halved succeeds",
        arguments: Self.halvingArguments
    )
    internal func halvedSucceeds(
        dividend: Double,
        quotient: Double
    ) {
        let result: Double = dividend.halved()
        #expect(result == quotient)
    }

    @Test(
        "Halve succeeds",
        arguments: Self.halvingArguments
    )
    internal func halveSucceeds(
        dividend: Double,
        quotient: Double
    ) {
        var result: Double = dividend
        result.halve()
        #expect(result == quotient)
    }
}

extension DoubleDivisibleTests {
    @Test(
        "Division is not commutative",
        arguments: Self.divisionArguments
    )
    internal func divisionIsNotCommutative(
        dividend: Double,
        divisor: Double.Divisor,
        quotient _: Double
    ) {
        let result: Double = dividend / divisor
        #expect(result != divisor / dividend)
    }
}

// MARK: - NaN

extension DoubleDivisibleTests {
    @Test(
        "NaN divisibility follows floating-point rules",
        arguments: [
            .zero,
            .negativeZero,
            2.0,
            .infinity,
            .negativeInfinity
        ] as Array<Double>
    )
    internal func nanDivisibilityFollowsFloatingPointRules(other: Double) {
        let isDivisibleResult: Bool = Double.nan.isDivisible(by: other)
        #expect(isDivisibleResult == false)
        let isFactorResult: Bool = Double.nan.isFactor(of: other)
        #expect(isFactorResult == false)
    }

    @Test("Reciprocal of NaN returns nil")
    internal func reciprocalOfNaNReturnsNil() {
        #expect(Double.nan.reciprocal == nil)
    }

    @Test("NaN is not invertible")
    internal func nanIsNotInvertible() {
        #expect(Double.nan.isInvertible == false)
    }

    @Test(
        "Dividing positive zero by positive or negative zero returns NaN",
        arguments: [
            .zero,
            .negativeZero
        ] as Array<Double.Divisor>
    )
    internal func dividingPositiveZeroByPositiveOrNegativeZeroReturnsNaN(divisor: Double.Divisor) {
        let result: Double = Double.zero / divisor
        #expect(result.isNaN == true)
    }

    @Test(
        "Dividing negative zero by positive or negative zero returns NaN",
        arguments: [
            .zero,
            .negativeZero
        ] as Array<Double.Divisor>
    )
    internal func dividingNegativeZeroByPositiveOrNegativeZeroReturnsNaN(divisor: Double.Divisor) {
        let result: Double = Double.negativeZero / divisor
        #expect(result.isNaN == true)
    }

    @Test(
        "Dividing positive infinity by infinity returns NaN",
        arguments: [
            .infinity,
            .negativeInfinity
        ] as Array<Double.Divisor>
    )
    internal func dividingPositiveInfinityByInfinityReturnsNaN(divisor: Double.Divisor) {
        let result: Double = Double.infinity / divisor
        #expect(result.isNaN == true)
    }

    @Test(
        "Dividing negative infinity by infinity returns NaN",
        arguments: [
            .infinity,
            .negativeInfinity
        ] as Array<Double.Divisor>
    )
    internal func dividingNegativeInfinityByInfinityReturnsNaN(divisor: Double.Divisor) {
        let result: Double = Double.negativeInfinity / divisor
        #expect(result.isNaN == true)
    }

    @Test(
        "Dividing NaN returns NaN",
        arguments: [
            .nan,
            .zero,
            .negativeZero,
            1.0,
            -1.0,
            .infinity,
            .negativeInfinity
        ] as Array<Double.Divisor>
    )
    internal func dividingNaNReturnsNaN(divisor: Double.Divisor) {
        let result: Double = Double.nan / divisor
        #expect(result.isNaN == true)
    }

    @Test(
        "Dividing by NaN returns NaN",
        arguments: [
            .zero,
            .negativeZero,
            1.0,
            -1.0,
            .infinity,
            .negativeInfinity
        ] as Array<Double>
    )
    internal func dividingByNaNReturnsNaN(dividend: Double) {
        let result: Double = dividend / Double.nan
        #expect(result.isNaN == true)
    }

    @Test(
        "Remainder of positive infinity returns NaN",
        arguments: [
            .zero,
            .negativeZero,
            1.0,
            -1.0,
            .infinity,
            .negativeInfinity
        ] as Array<Double.RemainderDivisor>
    )
    internal func remainderOfPositiveInfinityReturnsNaN(divisor: Double.RemainderDivisor) {
        let result: Double = Double.infinity % divisor
        #expect(result.isNaN == true)
    }

    @Test(
        "Remainder of negative infinity returns NaN",
        arguments: [
            .zero,
            .negativeZero,
            1.0,
            -1.0,
            .infinity,
            .negativeInfinity
        ] as Array<Double.RemainderDivisor>
    )
    internal func remainderOfNegativeInfinityReturnsNaN(divisor: Double.RemainderDivisor) {
        let result: Double = Double.negativeInfinity % divisor
        #expect(result.isNaN == true)
    }

    @Test(
        "Remainder by positive zero returns NaN",
        arguments: [
            1.0,
            -1.0
        ] as Array<Double>
    )
    internal func remainderByPositiveZeroReturnsNaN(dividend: Double) {
        let result: Double = dividend % Double.zero
        #expect(result.isNaN == true)
    }

    @Test(
        "Remainder by negative zero returns NaN",
        arguments: [
            1.0,
            -1.0
        ] as Array<Double>
    )
    internal func remainderByNegativeZeroReturnsNaN(dividend: Double) {
        let result: Double = dividend % Double.negativeZero
        #expect(result.isNaN == true)
    }

    @Test(
        "Remainder of NaN returns NaN",
        arguments: [
            .nan,
            .zero,
            .negativeZero,
            1.0,
            -1.0,
            .infinity,
            .negativeInfinity
        ] as Array<Double.RemainderDivisor>
    )
    internal func remainderOfNaNReturnsNaN(divisor: Double.RemainderDivisor) {
        let result: Double = Double.nan % divisor
        #expect(result.isNaN == true)
    }

    @Test(
        "Remainder by NaN returns NaN",
        arguments: [
            .zero,
            .negativeZero,
            1.0,
            -1.0,
            .infinity,
            .negativeInfinity
        ] as Array<Double>
    )
    internal func remainderByNaNReturnsNaN(dividend: Double) {
        let result: Double = dividend % Double.nan
        #expect(result.isNaN == true)
    }
}

// MARK: - Negative Infinity

extension DoubleDivisibleTests {
    @Test(
        "Negative infinity divisibility follows floating-point rules",
        arguments: [
            .zero,
            .negativeZero,
            2.0,
            .infinity,
            .negativeInfinity
        ] as Array<Double>
    )
    internal func negativeInfinityDivisibilityFollowsFloatingPointRules(other: Double) {
        let isDivisibleResult: Bool = Double.negativeInfinity.isDivisible(by: other)
        #expect(isDivisibleResult == false)
        let isFactorResult: Bool = Double.negativeInfinity.isFactor(of: other)
        #expect(isFactorResult == false)
    }

    @Test("Reciprocal of negative infinity returns negative zero")
    internal func reciprocalOfNegativeInfinityReturnsNegativeZero() {
        let result: Double.Reciprocal? = Double.negativeInfinity.reciprocal
        #expect(result == Double.zero)
        #expect(result?.sign == .minus)
    }

    @Test("Negative infinity is invertible")
    internal func negativeInfinityIsInvertible() {
        #expect(Double.negativeInfinity.isInvertible == true)
    }

    @Test(
        "Dividing negative infinity follows floating-point rules",
        arguments: [
            (1.0, .negativeInfinity),
            (-1.0, .infinity)
        ] as Array<(Double.Divisor, Double)>
    )
    internal func dividingNegativeInfinityFollowsFloatingPointRules(
        divisor: Double.Divisor,
        quotient: Double
    ) {
        let result: Double = Double.negativeInfinity / divisor
        #expect(result == quotient)
    }

    @Test(
        "Dividing by negative infinity follows floating-point rules",
        arguments: [
            (1.0, .negativeZero),
            (-1.0, .zero)
        ] as Array<(Double, Double)>
    )
    internal func dividingByNegativeInfinityFollowsFloatingPointRules(
        dividend: Double,
        quotient: Double
    ) {
        let result: Double = dividend / Double.negativeInfinity
        #expect(result == quotient)
        #expect(result.sign == quotient.sign)
    }

    @Test(
        "Remainder by negative infinity preserves dividend",
        arguments: [
            0.5,
            -0.5,
            .zero,
            .negativeZero
        ] as Array<Double>
    )
    internal func remainderByNegativeInfinityPreservesDividend(dividend: Double) {
        let result: Double = dividend % Double.negativeInfinity
        #expect(result == dividend)
        #expect(result.sign == dividend.sign)
    }
}

// MARK: - Negative One

extension DoubleDivisibleTests {
    @Test(
        "Dividing by negative one returns opposite value",
        arguments: [
            (6.0, -6.0),
            (4.0, -4.0),
            (-6.0, 6.0),
            (-4.0, 4.0),
            (1.5, -1.5),
            (3.75, -3.75),
            (-1.5, 1.5),
            (-3.75, 3.75)
        ] as Array<(Double, Double)>
    )
    internal func dividingByNegativeOneReturnsOppositeValue(
        dividend: Double,
        quotient: Double
    ) {
        let result: Double = dividend / -1.0
        #expect(result == quotient)
    }
}

// MARK: - Negative Zero

extension DoubleDivisibleTests {
    @Test(
        "Remainder by self returns negative zero",
        arguments: [
            -6.0,
            -4.0,
            -1.5,
            -3.75
        ] as Array<Double>
    )
    internal func remainderBySelfReturnsNegativeZero(value: Double) {
        let result: Double = value % value
        #expect(result == Double.zero)
        #expect(result.sign == .minus)
    }

    @Test(
        "Negative zero divisibility follows floating-point rules",
        arguments: [
            (.zero, false, false),
            (.negativeZero, false, false),
            (2.0, true, false),
            (.infinity, false, false),
            (.negativeInfinity, false, false)
        ] as Array<(Double, Bool, Bool)>
    )
    internal func negativeZeroDivisibilityFollowsFloatingPointRules(
        other: Double,
        isDivisible: Bool,
        isFactor: Bool
    ) {
        let isDivisibleResult: Bool = Double.negativeZero.isDivisible(by: other)
        #expect(isDivisibleResult == isDivisible)
        let isFactorResult: Bool = Double.negativeZero.isFactor(of: other)
        #expect(isFactorResult == isFactor)
    }

    @Test("Reciprocal of negative zero returns nil")
    internal func reciprocalOfNegativeZeroReturnsNil() {
        #expect(Double.negativeZero.reciprocal == nil)
    }

    @Test("Negative zero is not invertible")
    internal func negativeZeroIsNotInvertible() {
        #expect(Double.negativeZero.isInvertible == false)
    }

    @Test(
        "Dividing negative zero follows floating-point rules",
        arguments: [
            (1.0, .negativeZero),
            (-1.0, .zero)
        ] as Array<(Double.Divisor, Double)>
    )
    internal func dividingNegativeZeroFollowsFloatingPointRules(
        divisor: Double.Divisor,
        quotient: Double
    ) {
        let result: Double = Double.negativeZero / divisor
        #expect(result == quotient)
        #expect(result.sign == quotient.sign)
    }

    @Test(
        "Dividing by negative zero follows floating-point rules",
        arguments: [
            (1.0, .negativeInfinity),
            (-1.0, .infinity)
        ] as Array<(Double, Double)>
    )
    internal func dividingByNegativeZeroFollowsFloatingPointRules(
        dividend: Double,
        quotient: Double
    ) {
        let result: Double = dividend / Double.negativeZero
        #expect(result == quotient)
    }
}

// MARK: - Positive Infinity

extension DoubleDivisibleTests {
    @Test(
        "Positive infinity divisibility follows floating-point rules",
        arguments: [
            .zero,
            .negativeZero,
            2.0,
            .infinity,
            .negativeInfinity
        ] as Array<Double>
    )
    internal func positiveInfinityDivisibilityFollowsFloatingPointRules(other: Double) {
        let isDivisibleResult: Bool = Double.infinity.isDivisible(by: other)
        #expect(isDivisibleResult == false)
        let isFactorResult: Bool = Double.infinity.isFactor(of: other)
        #expect(isFactorResult == false)
    }

    @Test("Reciprocal of positive infinity returns positive zero")
    internal func reciprocalOfPositiveInfinityReturnsPositiveZero() {
        let result: Double.Reciprocal? = Double.infinity.reciprocal
        #expect(result == Double.zero)
        #expect(result?.sign == .plus)
    }

    @Test("Positive infinity is invertible")
    internal func positiveInfinityIsInvertible() {
        #expect(Double.infinity.isInvertible == true)
    }

    @Test(
        "Dividing positive infinity follows floating-point rules",
        arguments: [
            (1.0, .infinity),
            (-1.0, .negativeInfinity)
        ] as Array<(Double.Divisor, Double)>
    )
    internal func dividingPositiveInfinityFollowsFloatingPointRules(
        divisor: Double.Divisor,
        quotient: Double
    ) {
        let result: Double = Double.infinity / divisor
        #expect(result == quotient)
    }

    @Test(
        "Dividing by positive infinity follows floating-point rules",
        arguments: [
            (1.0, .zero),
            (-1.0, .negativeZero)
        ] as Array<(Double, Double)>
    )
    internal func dividingByPositiveInfinityFollowsFloatingPointRules(
        dividend: Double,
        quotient: Double
    ) {
        let result: Double = dividend / Double.infinity
        #expect(result == quotient)
        #expect(result.sign == quotient.sign)
    }

    @Test(
        "Remainder by positive infinity preserves dividend",
        arguments: [
            0.5,
            -0.5,
            .zero,
            .negativeZero
        ] as Array<Double>
    )
    internal func remainderByPositiveInfinityPreservesDividend(dividend: Double) {
        let result: Double = dividend % Double.infinity
        #expect(result == dividend)
        #expect(result.sign == dividend.sign)
    }
}

// MARK: - Positive One

extension DoubleDivisibleTests {
    @Test(
        "Dividing by positive one preserves dividend",
        arguments: [
            6.0,
            4.0,
            -6.0,
            -4.0,
            1.5,
            3.75,
            -1.5,
            -3.75
        ] as Array<Double>
    )
    internal func dividingByPositiveOnePreservesDividend(dividend: Double) {
        let result: Double = dividend / 1.0
        #expect(result == dividend)
    }
}

// MARK: - Positive Zero

extension DoubleDivisibleTests {
    @Test(
        "Remainder by self returns positive zero",
        arguments: [
            6.0,
            4.0,
            1.5,
            3.75
        ] as Array<Double>
    )
    internal func remainderBySelfReturnsPositiveZero(value: Double) {
        let result: Double = value % value
        #expect(result == Double.zero)
        #expect(result.sign == .plus)
    }

    @Test(
        "Dividing positive zero by nonzero value returns positive or negative zero",
        arguments: [
            2.0,
            -3.0,
            3.0,
            0.5,
            1.5,
            -1.5
        ] as Array<Double.Divisor>
    )
    internal func dividingPositiveZeroByNonzeroValueReturnsPositiveOrNegativeZero(divisor: Double.Divisor) {
        let result: Double = Double.zero / divisor
        #expect(result == Double.zero)
    }

    @Test(
        "Positive zero divisibility follows floating-point rules",
        arguments: [
            (.zero, false, false),
            (.negativeZero, false, false),
            (2.0, true, false),
            (.infinity, false, false),
            (.negativeInfinity, false, false)
        ] as Array<(Double, Bool, Bool)>
    )
    internal func positiveZeroDivisibilityFollowsFloatingPointRules(
        other: Double,
        isDivisible: Bool,
        isFactor: Bool
    ) {
        let isDivisibleResult: Bool = Double.zero.isDivisible(by: other)
        #expect(isDivisibleResult == isDivisible)
        let isFactorResult: Bool = Double.zero.isFactor(of: other)
        #expect(isFactorResult == isFactor)
    }

    @Test("Reciprocal of positive zero returns nil")
    internal func reciprocalOfPositiveZeroReturnsNil() {
        #expect(Double.zero.reciprocal == nil)
    }

    @Test("Positive zero is not invertible")
    internal func positiveZeroIsNotInvertible() {
        #expect(Double.zero.isInvertible == false)
    }

    @Test(
        "Dividing positive zero follows floating-point rules",
        arguments: [
            (1.0, .zero),
            (-1.0, .negativeZero)
        ] as Array<(Double.Divisor, Double)>
    )
    internal func dividingPositiveZeroFollowsFloatingPointRules(
        divisor: Double.Divisor,
        quotient: Double
    ) {
        let result: Double = Double.zero / divisor
        #expect(result == quotient)
        #expect(result.sign == quotient.sign)
    }

    @Test(
        "Dividing by positive zero follows floating-point rules",
        arguments: [
            (1.0, .infinity),
            (-1.0, .negativeInfinity)
        ] as Array<(Double, Double)>
    )
    internal func dividingByPositiveZeroFollowsFloatingPointRules(
        dividend: Double,
        quotient: Double
    ) {
        let result: Double = dividend / Double.zero
        #expect(result == quotient)
    }
}
