// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Double Multipliable Tests")
internal struct DoubleMultipliableTests {
    private static let multiplicationArguments: [(Double, Double, Double)] = [
        (2.0, 3.0, 6.0),
        (3.0, 4.0, 12.0),
        (-2.0, 3.0, -6.0),
        (-3.0, -4.0, 12.0),
        (0.5, 1.5, 0.75),
        (1.5, 2.5, 3.75),
        (-0.5, 1.5, -0.75),
        (-1.5, -2.5, 3.75)
    ]

    private static let doublingArguments: [(Double, Double)] = [
        (2.0, 4.0),
        (3.0, 6.0),
        (-2.0, -4.0),
        (-3.0, -6.0),
        (0.5, 1.0),
        (1.5, 3.0),
        (-0.5, -1.0),
        (-1.5, -3.0)
    ]

    @Test(
        "Is multiple of",
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
    internal func isMultipleOf(
        multiplicand: Double,
        multiplier: Double,
        result: Bool
    ) {
        #expect(multiplicand.isMultiple(of: multiplier) == result)
    }

    @Test(
        "Multiplication succeeds",
        arguments: Self.multiplicationArguments
    )
    internal func multiplicationSucceeds(
        multiplicand: Double,
        multiplier: Double,
        product: Double
    ) {
        #expect(multiplicand * multiplier == product)
    }

    @Test(
        "Multiplication equal succeeds",
        arguments: Self.multiplicationArguments
    )
    internal func multiplicationEqualSucceeds(
        multiplicand: Double,
        multiplier: Double,
        product: Double
    ) {
        var runningProduct: Double = multiplicand
        runningProduct *= multiplier
        #expect(runningProduct == product)
    }

    @Test(
        "Multiplying by succeeds",
        arguments: Self.multiplicationArguments
    )
    internal func multiplyingBySucceeds(
        multiplicand: Double,
        multiplier: Double,
        product: Double
    ) {
        #expect(multiplicand.multiplying(by: multiplier) == product)
    }

    @Test(
        "Multiply by succeeds",
        arguments: Self.multiplicationArguments
    )
    internal func multiplyBySucceeds(
        multiplicand: Double,
        multiplier: Double,
        product: Double
    ) {
        var runningProduct: Double = multiplicand
        runningProduct.multiply(by: multiplier)
        #expect(runningProduct == product)
    }

    @Test(
        "Doubled succeeds",
        arguments: Self.doublingArguments
    )
    internal func doubledSucceeds(
        multiplicand: Double,
        product: Double
    ) {
        #expect(multiplicand.doubled() == product)
    }

    @Test(
        "Double succeeds",
        arguments: Self.doublingArguments
    )
    internal func doubleSucceeds(
        multiplicand: Double,
        product: Double
    ) {
        var runningProduct: Double = multiplicand
        runningProduct.double()
        #expect(runningProduct == product)
    }
}

extension DoubleMultipliableTests {
    @Test(
        "Multiplication is commutative",
        arguments: Self.multiplicationArguments
    )
    internal func multiplicationIsCommutative(
        multiplicand: Double,
        multiplier: Double,
        product _: Double
    ) {
        #expect(multiplicand * multiplier == multiplier * multiplicand)
    }
}

// MARK: - NaN

extension DoubleMultipliableTests {
    @Test(
        "NaN multiple predicate follows floating-point rules",
        arguments: [
            Double.zero,
            Double.negativeZero,
            2.0,
            Double.infinity,
            Double.negativeInfinity
        ]
    )
    internal func nanMultiplePredicateFollowsFloatingPointRules(other: Double) {
        #expect(Double.nan.isMultiple(of: other) == false)
        #expect(other.isMultiple(of: .nan) == false)
    }

    @Test(
        "Multiplying positive zero by infinity returns NaN",
        arguments: [
            (Double.zero, Double.infinity),
            (Double.zero, Double.negativeInfinity),
            (Double.infinity, Double.zero),
            (Double.negativeInfinity, Double.zero)
        ]
    )
    internal func multiplyingPositiveZeroByInfinityReturnsNaN(
        multiplicand: Double,
        multiplier: Double
    ) {
        #expect((multiplicand * multiplier).isNaN == true)
    }

    @Test(
        "Multiplying negative zero by infinity returns NaN",
        arguments: [
            (Double.negativeZero, Double.infinity),
            (Double.negativeZero, Double.negativeInfinity),
            (Double.infinity, Double.negativeZero),
            (Double.negativeInfinity, Double.negativeZero)
        ]
    )
    internal func multiplyingNegativeZeroByInfinityReturnsNaN(
        multiplicand: Double,
        multiplier: Double
    ) {
        #expect((multiplicand * multiplier).isNaN == true)
    }

    @Test(
        "Multiplying NaN returns NaN",
        arguments: [
            Double.nan,
            Double.zero,
            Double.negativeZero,
            1.0,
            Double.infinity,
            Double.negativeInfinity
        ]
    )
    internal func multiplyingNaNReturnsNaN(multiplier: Double) {
        #expect((Double.nan * multiplier).isNaN == true)
    }

    @Test(
        "Multiplying by NaN returns NaN",
        arguments: [
            Double.zero,
            Double.negativeZero,
            1.0,
            -1.0,
            Double.infinity,
            Double.negativeInfinity
        ]
    )
    internal func multiplyingByNaNReturnsNaN(multiplicand: Double) {
        #expect((multiplicand * Double.nan).isNaN == true)
    }
}

// MARK: - Negative Infinity

extension DoubleMultipliableTests {
    @Test(
        "Negative infinity multiple predicate follows floating-point rules",
        arguments: [
            Double.zero,
            Double.negativeZero,
            2.0,
            Double.infinity,
            Double.negativeInfinity
        ]
    )
    internal func negativeInfinityMultiplePredicateFollowsFloatingPointRules(other: Double) {
        #expect(Double.negativeInfinity.isMultiple(of: other) == false)
    }

    @Test(
        "Multiplying negative infinity follows floating-point rules",
        arguments: [
            (Double.infinity, Double.negativeInfinity),
            (Double.negativeInfinity, Double.infinity),
            (1.0, Double.negativeInfinity),
            (-1.0, Double.infinity)
        ]
    )
    internal func multiplyingNegativeInfinityFollowsFloatingPointRules(
        multiplier: Double,
        product: Double
    ) {
        #expect(Double.negativeInfinity * multiplier == product)
    }
}

// MARK: - Negative One

extension DoubleMultipliableTests {
    @Test(
        "Multiplying by negative one returns opposite value",
        arguments: [
            (2.0, -2.0),
            (3.0, -3.0),
            (-2.0, 2.0),
            (-3.0, 3.0),
            (0.5, -0.5),
            (1.5, -1.5),
            (-0.5, 0.5),
            (-1.5, 1.5)
        ]
    )
    internal func multiplyingByNegativeOneReturnsOppositeValue(
        multiplicand: Double,
        product: Double
    ) {
        #expect(multiplicand * -1.0 == product)
    }
}

// MARK: - Negative Zero

extension DoubleMultipliableTests {
    @Test(
        "Is multiple of negative zero returns false",
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
    internal func isMultipleOfNegativeZeroReturnsFalse(multiplicand: Double) {
        #expect(multiplicand.isMultiple(of: Double.negativeZero) == false)
    }

    @Test(
        "Negative zero multiple predicate follows floating-point rules",
        arguments: [
            (Double.zero, true),
            (Double.negativeZero, true),
            (2.0, true),
            (Double.infinity, true),
            (Double.negativeInfinity, true)
        ]
    )
    internal func negativeZeroMultiplePredicateFollowsFloatingPointRules(
        other: Double,
        result: Bool
    ) {
        #expect(Double.negativeZero.isMultiple(of: other) == result)
    }

    @Test(
        "Multiplying negative zero follows floating-point rules",
        arguments: [
            (Double.zero, Double.negativeZero),
            (Double.negativeZero, Double.zero),
            (1.0, Double.negativeZero),
            (-1.0, Double.zero)
        ]
    )
    internal func multiplyingNegativeZeroFollowsFloatingPointRules(
        multiplier: Double,
        product: Double
    ) {
        let result: Double = Double.negativeZero * multiplier

        #expect(result == product)
        #expect(result.sign == product.sign)
    }
}

// MARK: - Positive Infinity

extension DoubleMultipliableTests {
    @Test(
        "Positive infinity multiple predicate follows floating-point rules",
        arguments: [
            Double.zero,
            Double.negativeZero,
            2.0,
            Double.infinity,
            Double.negativeInfinity
        ]
    )
    internal func positiveInfinityMultiplePredicateFollowsFloatingPointRules(other: Double) {
        #expect(Double.infinity.isMultiple(of: other) == false)
    }

    @Test(
        "Multiplying positive infinity follows floating-point rules",
        arguments: [
            (Double.infinity, Double.infinity),
            (Double.negativeInfinity, Double.negativeInfinity),
            (1.0, Double.infinity),
            (-1.0, Double.negativeInfinity)
        ]
    )
    internal func multiplyingPositiveInfinityFollowsFloatingPointRules(
        multiplier: Double,
        product: Double
    ) {
        #expect(Double.infinity * multiplier == product)
    }
}

// MARK: - Positive One

extension DoubleMultipliableTests {
    @Test(
        "Multiplying by positive one preserves multiplicand",
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
    internal func multiplyingByPositiveOnePreservesMultiplicand(multiplicand: Double) {
        #expect(multiplicand * 1.0 == multiplicand)
    }
}

// MARK: - Positive Zero

extension DoubleMultipliableTests {
    @Test(
        "Is multiple of positive zero returns false",
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
    internal func isMultipleOfPositiveZeroReturnsFalse(multiplicand: Double) {
        #expect(multiplicand.isMultiple(of: Double.zero) == false)
    }

    @Test(
        "Multiplying by positive zero returns positive or negative zero",
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
    internal func multiplyingByPositiveZeroReturnsPositiveOrNegativeZero(multiplicand: Double) {
        #expect(multiplicand * Double.zero == Double.zero)
    }

    @Test(
        "Positive zero multiple predicate follows floating-point rules",
        arguments: [
            (Double.zero, true),
            (Double.negativeZero, true),
            (2.0, true),
            (Double.infinity, true),
            (Double.negativeInfinity, true)
        ]
    )
    internal func positiveZeroMultiplePredicateFollowsFloatingPointRules(
        other: Double,
        result: Bool
    ) {
        #expect(Double.zero.isMultiple(of: other) == result)
    }

    @Test(
        "Multiplying positive zero follows floating-point rules",
        arguments: [
            (Double.zero, Double.zero),
            (Double.negativeZero, Double.negativeZero),
            (1.0, Double.zero),
            (-1.0, Double.negativeZero)
        ]
    )
    internal func multiplyingPositiveZeroFollowsFloatingPointRules(
        multiplier: Double,
        product: Double
    ) {
        let result: Double = Double.zero * multiplier

        #expect(result == product)
        #expect(result.sign == product.sign)
    }
}
