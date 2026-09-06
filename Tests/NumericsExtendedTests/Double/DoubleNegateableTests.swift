// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Double Negateable Tests")
internal struct DoubleNegateableTests {
    private static let negationArguments: Array<(Double, Double)> = [
        (1.0, -1.0),
        (-1.0, 1.0),
        (5.0, -5.0),
        (-5.0, 5.0),
        (0.5, -0.5),
        (-0.5, 0.5),
        (1.5, -1.5),
        (-1.5, 1.5)
    ]

    private static let additiveInverseArguments: Array<Double> = [
        0.0,
        -0.0,
        1.0,
        -1.0,
        5.0,
        -5.0,
        0.5,
        -0.5,
        1.5,
        -1.5
    ]

    @Test(
        "Negation succeeds",
        arguments: Self.negationArguments
    )
    internal func negationSucceeds(
        value: Double,
        negation: Double
    ) {
        #expect(-value == negation)
    }

    @Test(
        "Negating succeeds",
        arguments: Self.negationArguments
    )
    internal func negatingSucceeds(
        value: Double,
        negation: Double
    ) {
        #expect(value.negating() == negation)
    }

    @Test(
        "Negate succeeds",
        arguments: Self.negationArguments
    )
    internal func negateSucceeds(
        value: Double,
        negation: Double
    ) {
        var runningValue: Double = value
        runningValue.negate()
        #expect(runningValue == negation)
    }

    @Test(
        "Is negative",
        arguments: [
            (1.0, false),
            (-1.0, true),
            (5.0, false),
            (-5.0, true),
            (0.5, false),
            (-0.5, true),
            (1.5, false),
            (-1.5, true)
        ]
    )
    internal func isNegative(
        value: Double,
        result: Bool
    ) {
        #expect(value.isNegative == result)
    }

    @Test(
        "Is positive",
        arguments: [
            (1.0, true),
            (-1.0, false),
            (5.0, true),
            (-5.0, false),
            (0.5, true),
            (-0.5, false),
            (1.5, true),
            (-1.5, false)
        ]
    )
    internal func isPositive(
        value: Double,
        result: Bool
    ) {
        #expect(value.isPositive == result)
    }

    @Test(
        "Is signed",
        arguments: [
            (1.0, true),
            (-1.0, true),
            (5.0, true),
            (-5.0, true),
            (0.5, true),
            (-0.5, true),
            (1.5, true),
            (-1.5, true)
        ]
    )
    internal func isSigned(
        value: Double,
        result: Bool
    ) {
        #expect(value.isSigned == result)
    }

    @Test(
        "Is opposite",
        arguments: [
            (1.0, 1.0, false),
            (-1.0, -1.0, false),
            (-1.0, 1.0, true),
            (1.0, -1.0, true),
            (0.5, 0.5, false),
            (-0.5, -0.5, false),
            (-0.5, 0.5, true),
            (0.5, -0.5, true)
        ]
    )
    internal func isOpposite(
        value: Double,
        other: Double,
        result: Bool
    ) {
        #expect(value.isOpposite(of: other) == result)
    }
}

extension DoubleNegateableTests {
    @Test(
        "Negating twice returns original value",
        arguments: Self.additiveInverseArguments
    )
    internal func negatingTwiceReturnsOriginalValue(value: Double) {
        #expect(value.negating().negating() == value)
    }
}

// MARK: - NaN

extension DoubleNegateableTests {
    @Test("NaN sign predicates follow floating-point rules")
    internal func nanSignPredicatesFollowFloatingPointRules() {
        #expect(Double.nan.isNegative == false)
        #expect(Double.nan.isPositive == false)
        #expect(Double.nan.isSigned == true)
    }

    @Test(
        "NaN opposite follows floating-point rules",
        arguments: [
            Double.zero,
            Double.negativeZero,
            1.0,
            Double.infinity,
            Double.negativeInfinity
        ]
    )
    internal func nanOppositeFollowsFloatingPointRules(other: Double) {
        #expect(Double.nan.isOpposite(of: other) == false)
        #expect(other.isOpposite(of: .nan) == false)
    }

    @Test("Negating NaN returns NaN")
    internal func negatingNaNReturnsNaN() {
        let operatorNegation: Double = -Double.nan
        let methodNegation: Double = Double.nan.negating()
        var mutatingNegation: Double = Double.nan
        mutatingNegation.negate()

        #expect(operatorNegation.isNaN == true)
        #expect(methodNegation.isNaN == true)
        #expect(mutatingNegation.isNaN == true)
    }
}

// MARK: - Negative Infinity

extension DoubleNegateableTests {
    @Test("Negative infinity sign predicates follow floating-point rules")
    internal func negativeInfinitySignPredicatesFollowFloatingPointRules() {
        #expect(Double.negativeInfinity.isNegative == true)
        #expect(Double.negativeInfinity.isPositive == false)
        #expect(Double.negativeInfinity.isSigned == true)
    }

    @Test(
        "Negative infinity opposite follows floating-point rules",
        arguments: [
            (Double.negativeInfinity, false),
            (Double.infinity, true)
        ]
    )
    internal func negativeInfinityOppositeFollowsFloatingPointRules(
        other: Double,
        result: Bool
    ) {
        #expect(Double.negativeInfinity.isOpposite(of: other) == result)
    }

    @Test("Negating negative infinity follows floating-point rules")
    internal func negatingNegativeInfinityFollowsFloatingPointRules() {
        let operatorNegation: Double = -Double.negativeInfinity
        let methodNegation: Double = Double.negativeInfinity.negating()
        var mutatingNegation: Double = Double.negativeInfinity
        mutatingNegation.negate()

        #expect(operatorNegation == .infinity)
        #expect(methodNegation == .infinity)
        #expect(mutatingNegation == .infinity)
    }
}

// MARK: - Negative Zero

extension DoubleNegateableTests {
    @Test("Negative zero sign predicates follow floating-point rules")
    internal func negativeZeroSignPredicatesFollowFloatingPointRules() {
        #expect(Double.negativeZero.isNegative == false)
        #expect(Double.negativeZero.isPositive == false)
        #expect(Double.negativeZero.isSigned == true)
    }

    @Test(
        "Negative zero opposite follows floating-point rules",
        arguments: [
            (Double.zero, true),
            (Double.negativeZero, true)
        ]
    )
    internal func negativeZeroOppositeFollowsFloatingPointRules(
        other: Double,
        result: Bool
    ) {
        #expect(Double.negativeZero.isOpposite(of: other) == result)
    }

    @Test("Negating negative zero follows floating-point rules")
    internal func negatingNegativeZeroFollowsFloatingPointRules() {
        let operatorNegation: Double = -Double.negativeZero
        let methodNegation: Double = Double.negativeZero.negating()
        var mutatingNegation: Double = Double.negativeZero
        mutatingNegation.negate()

        #expect(operatorNegation == .zero)
        #expect(operatorNegation.sign == .plus)
        #expect(methodNegation == .zero)
        #expect(methodNegation.sign == .plus)
        #expect(mutatingNegation == .zero)
        #expect(mutatingNegation.sign == .plus)
    }
}

// MARK: - Positive Infinity

extension DoubleNegateableTests {
    @Test("Positive infinity sign predicates follow floating-point rules")
    internal func positiveInfinitySignPredicatesFollowFloatingPointRules() {
        #expect(Double.infinity.isNegative == false)
        #expect(Double.infinity.isPositive == true)
        #expect(Double.infinity.isSigned == true)
    }

    @Test(
        "Positive infinity opposite follows floating-point rules",
        arguments: [
            (Double.infinity, false),
            (Double.negativeInfinity, true)
        ]
    )
    internal func positiveInfinityOppositeFollowsFloatingPointRules(
        other: Double,
        result: Bool
    ) {
        #expect(Double.infinity.isOpposite(of: other) == result)
    }

    @Test("Negating positive infinity follows floating-point rules")
    internal func negatingPositiveInfinityFollowsFloatingPointRules() {
        let operatorNegation: Double = -Double.infinity
        let methodNegation: Double = Double.infinity.negating()
        var mutatingNegation: Double = Double.infinity
        mutatingNegation.negate()

        #expect(operatorNegation == .negativeInfinity)
        #expect(methodNegation == .negativeInfinity)
        #expect(mutatingNegation == .negativeInfinity)
    }
}

// MARK: - Positive Zero

extension DoubleNegateableTests {
    @Test(
        "Adding value and its negation returns positive zero",
        arguments: Self.additiveInverseArguments
    )
    internal func addingValueAndItsNegationReturnsPositiveZero(value: Double) {
        let sum: Double = value + value.negating()
        #expect(sum == Double.zero)
        #expect(sum.sign == .plus)
    }

    @Test("Positive zero sign predicates follow floating-point rules")
    internal func positiveZeroSignPredicatesFollowFloatingPointRules() {
        #expect(Double.zero.isNegative == false)
        #expect(Double.zero.isPositive == false)
        #expect(Double.zero.isSigned == true)
    }

    @Test(
        "Positive zero opposite follows floating-point rules",
        arguments: [
            (Double.zero, true),
            (Double.negativeZero, true)
        ]
    )
    internal func positiveZeroOppositeFollowsFloatingPointRules(
        other: Double,
        result: Bool
    ) {
        #expect(Double.zero.isOpposite(of: other) == result)
    }

    @Test("Negating positive zero follows floating-point rules")
    internal func negatingPositiveZeroFollowsFloatingPointRules() {
        let operatorNegation: Double = -Double.zero
        let methodNegation: Double = Double.zero.negating()
        var mutatingNegation: Double = Double.zero
        mutatingNegation.negate()

        #expect(operatorNegation == .zero)
        #expect(operatorNegation.sign == .minus)
        #expect(methodNegation == .zero)
        #expect(methodNegation.sign == .minus)
        #expect(mutatingNegation == .zero)
        #expect(mutatingNegation.sign == .minus)
    }
}
