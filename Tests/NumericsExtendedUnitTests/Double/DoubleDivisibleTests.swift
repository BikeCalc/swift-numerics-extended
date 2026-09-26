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
    private static let divisionArguments: [(Double, Double, Double)] = [
        (6.0, 2.0, 3.0),
        (6.0, 3.0, 2.0),
        (-6.0, 2.0, -3.0),
        (-6.0, -3.0, 2.0),
        (1.5, 0.5, 3.0),
        (3.75, 1.5, 2.5),
        (-1.5, 0.5, -3.0),
        (-3.75, -1.5, 2.5)
    ]

    private static let remainderArguments: [(Double, Double, Double)] = [
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
        ]
    )
    internal func reciprocal(
        dividend: Double,
        result: Double?
    ) {
        #expect(dividend.reciprocal == result)
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
        ]
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
        ]
    )
    internal func isDivisibleBy(
        dividend: Double,
        divisor: Double,
        result: Bool
    ) {
        #expect(dividend.isDivisible(by: divisor) == result)
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
        ]
    )
    internal func isFactorOf(
        factor: Double,
        value: Double,
        result: Bool
    ) {
        #expect(factor.isFactor(of: value) == result)
    }

    @Test(
        "Division succeeds",
        arguments: Self.divisionArguments
    )
    internal func divisionSucceeds(
        dividend: Double,
        divisor: Double,
        quotient: Double
    ) {
        #expect(dividend / divisor == quotient)
    }

    @Test(
        "Division equal succeeds",
        arguments: Self.divisionArguments
    )
    internal func divisionEqualSucceeds(
        dividend: Double,
        divisor: Double,
        quotient: Double
    ) {
        var runningQuotient: Double = dividend
        runningQuotient /= divisor
        #expect(runningQuotient == quotient)
    }

    @Test(
        "Remainder succeeds",
        arguments: Self.remainderArguments
    )
    internal func remainderSucceeds(
        dividend: Double,
        divisor: Double,
        remainder: Double
    ) {
        #expect(dividend % divisor == remainder)
    }

    @Test(
        "Remainder equal succeeds",
        arguments: Self.remainderArguments
    )
    internal func remainderEqualSucceeds(
        dividend: Double,
        divisor: Double,
        remainder: Double
    ) {
        var runningRemainder: Double = dividend
        runningRemainder %= divisor
        #expect(runningRemainder == remainder)
    }

    @Test(
        "Dividing by succeeds",
        arguments: Self.divisionArguments
    )
    internal func dividingBySucceeds(
        dividend: Double,
        divisor: Double,
        quotient: Double
    ) {
        #expect(dividend.dividing(by: divisor) == quotient)
    }

    @Test(
        "Divide by succeeds",
        arguments: Self.divisionArguments
    )
    internal func divideBySucceeds(
        dividend: Double,
        divisor: Double,
        quotient: Double
    ) {
        var runningQuotient: Double = dividend
        runningQuotient.divide(by: divisor)
        #expect(runningQuotient == quotient)
    }

    @Test(
        "Halved succeeds",
        arguments: Self.halvingArguments
    )
    internal func halvedSucceeds(
        dividend: Double,
        quotient: Double
    ) {
        #expect(dividend.halved() == quotient)
    }

    @Test(
        "Halve succeeds",
        arguments: Self.halvingArguments
    )
    internal func halveSucceeds(
        dividend: Double,
        quotient: Double
    ) {
        var runningQuotient: Double = dividend
        runningQuotient.halve()
        #expect(runningQuotient == quotient)
    }
}

extension DoubleDivisibleTests {
    @Test(
        "Division is not commutative",
        arguments: Self.divisionArguments
    )
    internal func divisionIsNotCommutative(
        dividend: Double,
        divisor: Double,
        quotient _: Double
    ) {
        #expect(dividend / divisor != divisor / dividend)
    }
}

// MARK: - NaN

extension DoubleDivisibleTests {
    @Test(
        "NaN divisibility follows floating-point rules",
        arguments: [
            Double.zero,
            Double.negativeZero,
            2.0,
            Double.infinity,
            Double.negativeInfinity
        ]
    )
    internal func nanDivisibilityFollowsFloatingPointRules(other: Double) {
        #expect(Double.nan.isDivisible(by: other) == false)
        #expect(Double.nan.isFactor(of: other) == false)
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
            Double.zero,
            Double.negativeZero
        ]
    )
    internal func dividingPositiveZeroByPositiveOrNegativeZeroReturnsNaN(divisor: Double) {
        #expect((Double.zero / divisor).isNaN == true)
    }

    @Test(
        "Dividing negative zero by positive or negative zero returns NaN",
        arguments: [
            Double.zero,
            Double.negativeZero
        ]
    )
    internal func dividingNegativeZeroByPositiveOrNegativeZeroReturnsNaN(divisor: Double) {
        #expect((Double.negativeZero / divisor).isNaN == true)
    }

    @Test(
        "Dividing positive infinity by infinity returns NaN",
        arguments: [
            Double.infinity,
            Double.negativeInfinity
        ]
    )
    internal func dividingPositiveInfinityByInfinityReturnsNaN(divisor: Double) {
        #expect((Double.infinity / divisor).isNaN == true)
    }

    @Test(
        "Dividing negative infinity by infinity returns NaN",
        arguments: [
            Double.infinity,
            Double.negativeInfinity
        ]
    )
    internal func dividingNegativeInfinityByInfinityReturnsNaN(divisor: Double) {
        #expect((Double.negativeInfinity / divisor).isNaN == true)
    }

    @Test(
        "Dividing NaN returns NaN",
        arguments: [
            Double.nan,
            Double.zero,
            Double.negativeZero,
            1.0,
            -1.0,
            Double.infinity,
            Double.negativeInfinity
        ]
    )
    internal func dividingNaNReturnsNaN(divisor: Double) {
        #expect((Double.nan / divisor).isNaN == true)
    }

    @Test(
        "Dividing by NaN returns NaN",
        arguments: [
            Double.zero,
            Double.negativeZero,
            1.0,
            -1.0,
            Double.infinity,
            Double.negativeInfinity
        ]
    )
    internal func dividingByNaNReturnsNaN(dividend: Double) {
        #expect((dividend / Double.nan).isNaN == true)
    }

    @Test(
        "Remainder of positive infinity returns NaN",
        arguments: [
            Double.zero,
            Double.negativeZero,
            1.0,
            -1.0,
            Double.infinity,
            Double.negativeInfinity
        ]
    )
    internal func remainderOfPositiveInfinityReturnsNaN(divisor: Double) {
        #expect((Double.infinity % divisor).isNaN == true)
    }

    @Test(
        "Remainder of negative infinity returns NaN",
        arguments: [
            Double.zero,
            Double.negativeZero,
            1.0,
            -1.0,
            Double.infinity,
            Double.negativeInfinity
        ]
    )
    internal func remainderOfNegativeInfinityReturnsNaN(divisor: Double) {
        #expect((Double.negativeInfinity % divisor).isNaN == true)
    }

    @Test(
        "Remainder by positive zero returns NaN",
        arguments: [
            1.0,
            -1.0
        ]
    )
    internal func remainderByPositiveZeroReturnsNaN(dividend: Double) {
        #expect((dividend % Double.zero).isNaN == true)
    }

    @Test(
        "Remainder by negative zero returns NaN",
        arguments: [
            1.0,
            -1.0
        ]
    )
    internal func remainderByNegativeZeroReturnsNaN(dividend: Double) {
        #expect((dividend % Double.negativeZero).isNaN == true)
    }

    @Test(
        "Remainder of NaN returns NaN",
        arguments: [
            Double.nan,
            Double.zero,
            Double.negativeZero,
            1.0,
            -1.0,
            Double.infinity,
            Double.negativeInfinity
        ]
    )
    internal func remainderOfNaNReturnsNaN(divisor: Double) {
        #expect((Double.nan % divisor).isNaN == true)
    }

    @Test(
        "Remainder by NaN returns NaN",
        arguments: [
            Double.zero,
            Double.negativeZero,
            1.0,
            -1.0,
            Double.infinity,
            Double.negativeInfinity
        ]
    )
    internal func remainderByNaNReturnsNaN(dividend: Double) {
        #expect((dividend % Double.nan).isNaN == true)
    }
}

// MARK: - Negative Infinity

extension DoubleDivisibleTests {
    @Test(
        "Negative infinity divisibility follows floating-point rules",
        arguments: [
            Double.zero,
            Double.negativeZero,
            2.0,
            Double.infinity,
            Double.negativeInfinity
        ]
    )
    internal func negativeInfinityDivisibilityFollowsFloatingPointRules(other: Double) {
        #expect(Double.negativeInfinity.isDivisible(by: other) == false)
        #expect(Double.negativeInfinity.isFactor(of: other) == false)
    }

    @Test("Reciprocal of negative infinity returns negative zero")
    internal func reciprocalOfNegativeInfinityReturnsNegativeZero() {
        let reciprocal: Double? = Double.negativeInfinity.reciprocal

        #expect(reciprocal == Double.zero)
        #expect(reciprocal?.sign == .minus)
    }

    @Test("Negative infinity is invertible")
    internal func negativeInfinityIsInvertible() {
        #expect(Double.negativeInfinity.isInvertible == true)
    }

    @Test(
        "Dividing negative infinity follows floating-point rules",
        arguments: [
            (1.0, Double.negativeInfinity),
            (-1.0, Double.infinity)
        ]
    )
    internal func dividingNegativeInfinityFollowsFloatingPointRules(
        divisor: Double,
        quotient: Double
    ) {
        #expect(Double.negativeInfinity / divisor == quotient)
    }

    @Test(
        "Dividing by negative infinity follows floating-point rules",
        arguments: [
            (1.0, Double.negativeZero),
            (-1.0, Double.zero)
        ]
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
            Double.zero,
            Double.negativeZero
        ]
    )
    internal func remainderByNegativeInfinityPreservesDividend(dividend: Double) {
        let remainder: Double = dividend % Double.negativeInfinity

        #expect(remainder == dividend)
        #expect(remainder.sign == dividend.sign)
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
        ]
    )
    internal func dividingByNegativeOneReturnsOppositeValue(
        dividend: Double,
        quotient: Double
    ) {
        #expect(dividend / -1.0 == quotient)
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
        ]
    )
    internal func remainderBySelfReturnsNegativeZero(value: Double) {
        let remainder: Double = value % value
        #expect(remainder == Double.zero)
        #expect(remainder.sign == .minus)
    }

    @Test(
        "Negative zero divisibility follows floating-point rules",
        arguments: [
            (Double.zero, false, false),
            (Double.negativeZero, false, false),
            (2.0, true, false),
            (Double.infinity, false, false),
            (Double.negativeInfinity, false, false)
        ]
    )
    internal func negativeZeroDivisibilityFollowsFloatingPointRules(
        other: Double,
        isDivisible: Bool,
        isFactor: Bool
    ) {
        #expect(Double.negativeZero.isDivisible(by: other) == isDivisible)
        #expect(Double.negativeZero.isFactor(of: other) == isFactor)
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
            (1.0, Double.negativeZero),
            (-1.0, Double.zero)
        ]
    )
    internal func dividingNegativeZeroFollowsFloatingPointRules(
        divisor: Double,
        quotient: Double
    ) {
        let result: Double = Double.negativeZero / divisor

        #expect(result == quotient)
        #expect(result.sign == quotient.sign)
    }

    @Test(
        "Dividing by negative zero follows floating-point rules",
        arguments: [
            (1.0, Double.negativeInfinity),
            (-1.0, Double.infinity)
        ]
    )
    internal func dividingByNegativeZeroFollowsFloatingPointRules(
        dividend: Double,
        quotient: Double
    ) {
        #expect(dividend / Double.negativeZero == quotient)
    }
}

// MARK: - Positive Infinity

extension DoubleDivisibleTests {
    @Test(
        "Positive infinity divisibility follows floating-point rules",
        arguments: [
            Double.zero,
            Double.negativeZero,
            2.0,
            Double.infinity,
            Double.negativeInfinity
        ]
    )
    internal func positiveInfinityDivisibilityFollowsFloatingPointRules(other: Double) {
        #expect(Double.infinity.isDivisible(by: other) == false)
        #expect(Double.infinity.isFactor(of: other) == false)
    }

    @Test("Reciprocal of positive infinity returns positive zero")
    internal func reciprocalOfPositiveInfinityReturnsPositiveZero() {
        let reciprocal: Double? = Double.infinity.reciprocal

        #expect(reciprocal == Double.zero)
        #expect(reciprocal?.sign == .plus)
    }

    @Test("Positive infinity is invertible")
    internal func positiveInfinityIsInvertible() {
        #expect(Double.infinity.isInvertible == true)
    }

    @Test(
        "Dividing positive infinity follows floating-point rules",
        arguments: [
            (1.0, Double.infinity),
            (-1.0, Double.negativeInfinity)
        ]
    )
    internal func dividingPositiveInfinityFollowsFloatingPointRules(
        divisor: Double,
        quotient: Double
    ) {
        #expect(Double.infinity / divisor == quotient)
    }

    @Test(
        "Dividing by positive infinity follows floating-point rules",
        arguments: [
            (1.0, Double.zero),
            (-1.0, Double.negativeZero)
        ]
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
            Double.zero,
            Double.negativeZero
        ]
    )
    internal func remainderByPositiveInfinityPreservesDividend(dividend: Double) {
        let remainder: Double = dividend % Double.infinity

        #expect(remainder == dividend)
        #expect(remainder.sign == dividend.sign)
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
        ]
    )
    internal func dividingByPositiveOnePreservesDividend(dividend: Double) {
        #expect(dividend / 1.0 == dividend)
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
        ]
    )
    internal func remainderBySelfReturnsPositiveZero(value: Double) {
        let remainder: Double = value % value
        #expect(remainder == Double.zero)
        #expect(remainder.sign == .plus)
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
        ]
    )
    internal func dividingPositiveZeroByNonzeroValueReturnsPositiveOrNegativeZero(divisor: Double) {
        #expect(Double.zero / divisor == Double.zero)
    }

    @Test(
        "Positive zero divisibility follows floating-point rules",
        arguments: [
            (Double.zero, false, false),
            (Double.negativeZero, false, false),
            (2.0, true, false),
            (Double.infinity, false, false),
            (Double.negativeInfinity, false, false)
        ]
    )
    internal func positiveZeroDivisibilityFollowsFloatingPointRules(
        other: Double,
        isDivisible: Bool,
        isFactor: Bool
    ) {
        #expect(Double.zero.isDivisible(by: other) == isDivisible)
        #expect(Double.zero.isFactor(of: other) == isFactor)
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
            (1.0, Double.zero),
            (-1.0, Double.negativeZero)
        ]
    )
    internal func dividingPositiveZeroFollowsFloatingPointRules(
        divisor: Double,
        quotient: Double
    ) {
        let result: Double = Double.zero / divisor

        #expect(result == quotient)
        #expect(result.sign == quotient.sign)
    }

    @Test(
        "Dividing by positive zero follows floating-point rules",
        arguments: [
            (1.0, Double.infinity),
            (-1.0, Double.negativeInfinity)
        ]
    )
    internal func dividingByPositiveZeroFollowsFloatingPointRules(
        dividend: Double,
        quotient: Double
    ) {
        #expect(dividend / Double.zero == quotient)
    }
}
