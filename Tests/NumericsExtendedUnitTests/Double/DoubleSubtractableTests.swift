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
    internal init() {}

    private static let subtractionArguments: [(Double, Double.Subtrahend, Double)] = [
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
        subtrahend: Double.Subtrahend,
        difference: Double
    ) {
        let result: Double = minuend - subtrahend
        #expect(result == difference)
    }

    @Test(
        "Subtraction equal succeeds",
        arguments: Self.subtractionArguments
    )
    internal func subtractionEqualSucceeds(
        minuend: Double,
        subtrahend: Double.Subtrahend,
        difference: Double
    ) {
        var result: Double = minuend
        result -= subtrahend
        #expect(result == difference)
    }

    @Test(
        "Subtracting succeeds",
        arguments: Self.subtractionArguments
    )
    internal func subtractingSucceeds(
        minuend: Double,
        subtrahend: Double.Subtrahend,
        difference: Double
    ) throws {
        let result: Double = try minuend.subtracting(subtrahend)
        #expect(result == difference)
    }

    @Test(
        "Subtract succeeds",
        arguments: Self.subtractionArguments
    )
    internal func subtractSucceeds(
        minuend: Double,
        subtrahend: Double.Subtrahend,
        difference: Double
    ) throws {
        var result: Double = minuend
        try result.subtract(subtrahend)
        #expect(result == difference)
    }
}

extension DoubleSubtractableTests {
    @Test(
        "Subtraction is not commutative",
        arguments: Self.subtractionArguments
    )
    internal func subtractionIsNotCommutative(
        minuend: Double,
        subtrahend: Double.Subtrahend,
        difference _: Double
    ) {
        let result: Double = minuend - subtrahend
        #expect(result != subtrahend - minuend)
    }
}

// MARK: - NaN

extension DoubleSubtractableTests {
    @Test("Subtracting positive infinity from itself returns NaN")
    internal func subtractingPositiveInfinityFromItselfReturnsNaN() {
        let result: Double = Double.infinity - .infinity
        #expect(result.isNaN == true)
    }

    @Test("Subtracting negative infinity from itself returns NaN")
    internal func subtractingNegativeInfinityFromItselfReturnsNaN() {
        let result: Double = Double.negativeInfinity - .negativeInfinity
        #expect(result.isNaN == true)
    }

    @Test(
        "Subtracting from NaN returns NaN",
        arguments: [
            .nan,
            .zero,
            .negativeZero,
            1.0,
            .infinity,
            .negativeInfinity
        ] as Array<Double.Subtrahend>
    )
    internal func subtractingFromNaNReturnsNaN(subtrahend: Double.Subtrahend) {
        let result: Double = Double.nan - subtrahend
        #expect(result.isNaN == true)
    }

    @Test(
        "Subtracting NaN returns NaN",
        arguments: [
            .zero,
            .negativeZero,
            1.0,
            -1.0,
            .infinity,
            .negativeInfinity
        ] as Array<Double>
    )
    internal func subtractingNaNReturnsNaN(minuend: Double) {
        let result: Double = minuend - Double.nan
        #expect(result.isNaN == true)
    }
}

// MARK: - Negative Infinity

extension DoubleSubtractableTests {
    @Test(
        "Subtracting negative infinity follows floating-point rules",
        arguments: [
            (.negativeInfinity, .infinity, .negativeInfinity),
            (.negativeInfinity, 1.0, .negativeInfinity),
            (1.0, .negativeInfinity, .infinity)
        ] as Array<(Double, Double.Subtrahend, Double)>
    )
    internal func subtractingNegativeInfinityFollowsFloatingPointRules(
        minuend: Double,
        subtrahend: Double.Subtrahend,
        difference: Double
    ) {
        let result: Double = minuend - subtrahend
        #expect(result == difference)
    }
}

// MARK: - Negative Zero

extension DoubleSubtractableTests {
    @Test(
        "Subtracting from negative zero follows floating-point rules",
        arguments: [
            (.zero, .negativeZero),
            (.negativeZero, .zero),
            (1.0, -1.0),
            (-1.0, 1.0)
        ] as Array<(Double.Subtrahend, Double)>
    )
    internal func subtractingFromNegativeZeroFollowsFloatingPointRules(
        subtrahend: Double.Subtrahend,
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
            (.infinity, .negativeInfinity, .infinity),
            (.infinity, 1.0, .infinity),
            (1.0, .infinity, .negativeInfinity)
        ] as Array<(Double, Double.Subtrahend, Double)>
    )
    internal func subtractingPositiveInfinityFollowsFloatingPointRules(
        minuend: Double,
        subtrahend: Double.Subtrahend,
        difference: Double
    ) {
        let result: Double = minuend - subtrahend
        #expect(result == difference)
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
        ] as Array<Double>
    )
    internal func subtractingPositiveZeroPreservesMinuend(minuend: Double) {
        let result: Double = minuend - Double.zero
        #expect(result == minuend)
    }

    @Test(
        "Subtracting from positive zero follows floating-point rules",
        arguments: [
            (.zero, .zero),
            (.negativeZero, .zero),
            (1.0, -1.0),
            (-1.0, 1.0)
        ] as Array<(Double.Subtrahend, Double)>
    )
    internal func subtractingFromPositiveZeroFollowsFloatingPointRules(
        subtrahend: Double.Subtrahend,
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
        ] as Array<Double>
    )
    internal func subtractingSelfReturnsPositiveZero(value: Double) {
        let result: Double = value - value
        #expect(result == Double.zero)
        #expect(result.sign == .plus)
    }
}
