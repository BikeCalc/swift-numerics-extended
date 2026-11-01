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
    internal init() {}

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
        let result: Double = -value
        #expect(result == negation)
    }

    @Test(
        "Negating succeeds",
        arguments: Self.negationArguments
    )
    internal func negatingSucceeds(
        value: Double,
        negation: Double
    ) {
        let result: Double = value.negating()
        #expect(result == negation)
    }

    @Test(
        "Negate succeeds",
        arguments: Self.negationArguments
    )
    internal func negateSucceeds(
        value: Double,
        negation: Double
    ) {
        var result: Double = value
        result.negate()
        #expect(result == negation)
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
        expected: Bool
    ) {
        #expect(value.isNegative == expected)
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
        expected: Bool
    ) {
        #expect(value.isPositive == expected)
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
        expected: Bool
    ) {
        #expect(value.isSigned == expected)
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
        expected: Bool
    ) {
        let result: Bool = value.isOpposite(of: other)
        #expect(result == expected)
    }
}

extension DoubleNegateableTests {
    @Test(
        "Negating twice returns original value",
        arguments: Self.additiveInverseArguments
    )
    internal func negatingTwiceReturnsOriginalValue(value: Double) {
        let result: Double = value.negating().negating()
        #expect(result == value)
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
        let firstResult: Bool = Double.nan.isOpposite(of: other)
        #expect(firstResult == false)
        let secondResult: Bool = other.isOpposite(of: .nan)
        #expect(secondResult == false)
    }

    @Test("Negating NaN returns NaN")
    internal func negatingNaNReturnsNaN() {
        let operatorResult: Double = -Double.nan
        let methodResult: Double = Double.nan.negating()
        var mutatingResult: Double = Double.nan
        mutatingResult.negate()
        #expect(operatorResult.isNaN == true)
        #expect(methodResult.isNaN == true)
        #expect(mutatingResult.isNaN == true)
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
        expected: Bool
    ) {
        let result: Bool = Double.negativeInfinity.isOpposite(of: other)
        #expect(result == expected)
    }

    @Test("Negating negative infinity follows floating-point rules")
    internal func negatingNegativeInfinityFollowsFloatingPointRules() {
        let operatorResult: Double = -Double.negativeInfinity
        let methodResult: Double = Double.negativeInfinity.negating()
        var mutatingResult: Double = Double.negativeInfinity
        mutatingResult.negate()
        #expect(operatorResult == .infinity)
        #expect(methodResult == .infinity)
        #expect(mutatingResult == .infinity)
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
        expected: Bool
    ) {
        let result: Bool = Double.negativeZero.isOpposite(of: other)
        #expect(result == expected)
    }

    @Test("Negating negative zero follows floating-point rules")
    internal func negatingNegativeZeroFollowsFloatingPointRules() {
        let operatorResult: Double = -Double.negativeZero
        let methodResult: Double = Double.negativeZero.negating()
        var mutatingResult: Double = Double.negativeZero
        mutatingResult.negate()
        #expect(operatorResult == .zero)
        #expect(operatorResult.sign == .plus)
        #expect(methodResult == .zero)
        #expect(methodResult.sign == .plus)
        #expect(mutatingResult == .zero)
        #expect(mutatingResult.sign == .plus)
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
        expected: Bool
    ) {
        let result: Bool = Double.infinity.isOpposite(of: other)
        #expect(result == expected)
    }

    @Test("Negating positive infinity follows floating-point rules")
    internal func negatingPositiveInfinityFollowsFloatingPointRules() {
        let operatorResult: Double = -Double.infinity
        let methodResult: Double = Double.infinity.negating()
        var mutatingResult: Double = Double.infinity
        mutatingResult.negate()
        #expect(operatorResult == .negativeInfinity)
        #expect(methodResult == .negativeInfinity)
        #expect(mutatingResult == .negativeInfinity)
    }
}

// MARK: - Positive Zero

extension DoubleNegateableTests {
    @Test(
        "Adding value and its negation returns positive zero",
        arguments: Self.additiveInverseArguments
    )
    internal func addingValueAndItsNegationReturnsPositiveZero(value: Double) {
        let result: Double = value + value.negating()
        #expect(result == Double.zero)
        #expect(result.sign == .plus)
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
        expected: Bool
    ) {
        let result: Bool = Double.zero.isOpposite(of: other)
        #expect(result == expected)
    }

    @Test("Negating positive zero follows floating-point rules")
    internal func negatingPositiveZeroFollowsFloatingPointRules() {
        let operatorResult: Double = -Double.zero
        let methodResult: Double = Double.zero.negating()
        var mutatingResult: Double = Double.zero
        mutatingResult.negate()
        #expect(operatorResult == .zero)
        #expect(operatorResult.sign == .minus)
        #expect(methodResult == .zero)
        #expect(methodResult.sign == .minus)
        #expect(mutatingResult == .zero)
        #expect(mutatingResult.sign == .minus)
    }
}
