// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Double Subtractable Tests")
internal struct DoubleSubtractableTests {
    private static let subtractionArguments: [(Double, Double, Double)] = [
        (3.0, 2.0, 1.0),
        (5.0, 3.0, 2.0),
        (-3.0, 2.0, -5.0),
        (-5.0, -3.0, -2.0),
        (1.5, 0.5, 1.0),
        (3.5, 1.5, 2.0),
        (-1.5, 0.5, -2.0),
        (-3.5, -1.5, -2.0)
    ]

    @Test(
        "Subtraction succeeds",
        arguments: Self.subtractionArguments
    )
    internal func subtractionSucceeds(
        minuend: Double,
        subtrahend: Double,
        difference: Double
    ) {
        #expect(minuend - subtrahend == difference)
    }

    @Test(
        "Subtraction equal succeeds",
        arguments: Self.subtractionArguments
    )
    internal func subtractionEqualSucceeds(
        minuend: Double,
        subtrahend: Double,
        difference: Double
    ) {
        var runningDifference: Double = minuend
        runningDifference -= subtrahend
        #expect(runningDifference == difference)
    }

    @Test(
        "Subtracting succeeds",
        arguments: Self.subtractionArguments
    )
    internal func subtractingSucceeds(
        minuend: Double,
        subtrahend: Double,
        difference: Double
    ) {
        #expect(minuend.subtracting(subtrahend) == difference)
    }

    @Test(
        "Subtract succeeds",
        arguments: Self.subtractionArguments
    )
    internal func subtractSucceeds(
        minuend: Double,
        subtrahend: Double,
        difference: Double
    ) {
        var runningDifference: Double = minuend
        runningDifference.subtract(subtrahend)
        #expect(runningDifference == difference)
    }
}

extension DoubleSubtractableTests {
    @Test(
        "Subtraction is not commutative",
        arguments: Self.subtractionArguments
    )
    internal func subtractionIsNotCommutative(
        minuend: Double,
        subtrahend: Double,
        difference _: Double
    ) {
        #expect(minuend - subtrahend != subtrahend - minuend)
    }
}

// MARK: - NaN

extension DoubleSubtractableTests {
    @Test("Subtracting positive infinity from itself returns NaN")
    internal func subtractingPositiveInfinityFromItselfReturnsNaN() {
        #expect((Double.infinity - .infinity).isNaN == true)
    }

    @Test("Subtracting negative infinity from itself returns NaN")
    internal func subtractingNegativeInfinityFromItselfReturnsNaN() {
        #expect((Double.negativeInfinity - .negativeInfinity).isNaN == true)
    }

    @Test(
        "Subtracting from NaN returns NaN",
        arguments: [
            Double.nan,
            Double.zero,
            Double.negativeZero,
            1.0,
            Double.infinity,
            Double.negativeInfinity
        ]
    )
    internal func subtractingFromNaNReturnsNaN(subtrahend: Double) {
        #expect((Double.nan - subtrahend).isNaN == true)
    }

    @Test(
        "Subtracting NaN returns NaN",
        arguments: [
            Double.zero,
            Double.negativeZero,
            1.0,
            -1.0,
            Double.infinity,
            Double.negativeInfinity
        ]
    )
    internal func subtractingNaNReturnsNaN(minuend: Double) {
        #expect((minuend - Double.nan).isNaN == true)
    }
}

// MARK: - Negative Infinity

extension DoubleSubtractableTests {
    @Test(
        "Subtracting negative infinity follows floating-point rules",
        arguments: [
            (Double.negativeInfinity, Double.infinity, Double.negativeInfinity),
            (Double.negativeInfinity, 1.0, Double.negativeInfinity),
            (1.0, Double.negativeInfinity, Double.infinity)
        ]
    )
    internal func subtractingNegativeInfinityFollowsFloatingPointRules(
        minuend: Double,
        subtrahend: Double,
        difference: Double
    ) {
        #expect(minuend - subtrahend == difference)
    }
}

// MARK: - Negative Zero

extension DoubleSubtractableTests {
    @Test(
        "Subtracting from negative zero follows floating-point rules",
        arguments: [
            (Double.zero, Double.negativeZero),
            (Double.negativeZero, Double.zero),
            (1.0, -1.0),
            (-1.0, 1.0)
        ]
    )
    internal func subtractingFromNegativeZeroFollowsFloatingPointRules(
        subtrahend: Double,
        difference: Double
    ) {
        let result: Double = Double.negativeZero - subtrahend

        #expect(result == difference)
        #expect(result.sign == difference.sign)
    }
}

// MARK: - Positive Infinity

extension DoubleSubtractableTests {
    @Test(
        "Subtracting positive infinity follows floating-point rules",
        arguments: [
            (Double.infinity, Double.negativeInfinity, Double.infinity),
            (Double.infinity, 1.0, Double.infinity),
            (1.0, Double.infinity, Double.negativeInfinity)
        ]
    )
    internal func subtractingPositiveInfinityFollowsFloatingPointRules(
        minuend: Double,
        subtrahend: Double,
        difference: Double
    ) {
        #expect(minuend - subtrahend == difference)
    }
}

// MARK: - Positive Zero

extension DoubleSubtractableTests {
    @Test(
        "Subtracting positive zero preserves minuend",
        arguments: [
            3.0,
            5.0,
            -3.0,
            -5.0,
            1.5,
            3.5,
            -1.5,
            -3.5
        ]
    )
    internal func subtractingPositiveZeroPreservesMinuend(minuend: Double) {
        #expect(minuend - Double.zero == minuend)
    }

    @Test(
        "Subtracting from positive zero follows floating-point rules",
        arguments: [
            (Double.zero, Double.zero),
            (Double.negativeZero, Double.zero),
            (1.0, -1.0),
            (-1.0, 1.0)
        ]
    )
    internal func subtractingFromPositiveZeroFollowsFloatingPointRules(
        subtrahend: Double,
        difference: Double
    ) {
        let result: Double = Double.zero - subtrahend

        #expect(result == difference)
        #expect(result.sign == difference.sign)
    }

    @Test(
        "Subtracting self returns positive zero",
        arguments: [
            3.0,
            5.0,
            -3.0,
            -5.0,
            1.5,
            3.5,
            -1.5,
            -3.5
        ]
    )
    internal func subtractingSelfReturnsPositiveZero(value: Double) {
        let difference: Double = value - value
        #expect(difference == Double.zero)
        #expect(difference.sign == .plus)
    }
}
