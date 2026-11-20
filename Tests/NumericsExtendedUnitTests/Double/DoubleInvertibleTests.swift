// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Double Invertible Tests")
internal struct DoubleInvertibleTests {
    internal init() {}

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
}

// MARK: - Greatest Finite Magnitude

extension DoubleInvertibleTests {
    @Test(
        "Reciprocal of greatest finite magnitude returns nil",
        arguments: [
            .greatestFiniteMagnitude,
            -.greatestFiniteMagnitude
        ] as Array<Double>
    )
    internal func reciprocalOfGreatestFiniteMagnitudeReturnsNil(dividend: Double) {
        #expect(dividend.reciprocal == nil)
    }

    @Test(
        "Greatest Finite Magnitude is not invertible",
        arguments: [
            .greatestFiniteMagnitude,
            -.greatestFiniteMagnitude
        ] as Array<Double>
    )
    internal func greatestFiniteMagnitudeIsNotInvertible(dividend: Double) {
        #expect(dividend.isInvertible == false)
    }
}

// MARK: - Least Nonzero Magnitude

extension DoubleInvertibleTests {
    @Test(
        "Reciprocal of least nonzero magnitude returns nil",
        arguments: [
            .leastNonzeroMagnitude,
            -.leastNonzeroMagnitude
        ] as Array<Double>
    )
    internal func reciprocalOfLeastNonzeroMagnitudeReturnsNil(dividend: Double) {
        #expect(dividend.reciprocal == nil)
    }

    @Test(
        "Least Nonzero Magnitude is not invertible",
        arguments: [
            .leastNonzeroMagnitude,
            -.leastNonzeroMagnitude
        ] as Array<Double>
    )
    internal func leastNonzeroMagnitudeIsNotInvertible(dividend: Double) {
        #expect(dividend.isInvertible == false)
    }
}

// MARK: - NaN

extension DoubleInvertibleTests {
    @Test("Reciprocal of NaN returns NaN")
    internal func reciprocalOfNaNReturnsNaN() {
        #expect(Double.nan.reciprocal?.isNaN == true)
    }

    @Test("NaN is invertible")
    internal func nanIsInvertible() {
        #expect(Double.nan.isInvertible == true)
    }
}

// MARK: - Negative Infinity

extension DoubleInvertibleTests {
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
}

// MARK: - Negative Zero

extension DoubleInvertibleTests {
    @Test("Reciprocal of negative zero returns negative infinity")
    internal func reciprocalOfNegativeZeroReturnsNegativeInfinity() {
        #expect(Double.negativeZero.reciprocal == Double.negativeInfinity)
    }

    @Test("Negative zero is invertible")
    internal func negativeZeroIsInvertible() {
        #expect(Double.negativeZero.isInvertible == true)
    }
}

// MARK: - Positive Infinity

extension DoubleInvertibleTests {
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
}

// MARK: - Positive Zero

extension DoubleInvertibleTests {
    @Test("Reciprocal of positive zero returns positive infinity")
    internal func reciprocalOfPositiveZeroReturnsPositiveInfinity() {
        #expect(Double.zero.reciprocal == Double.infinity)
    }

    @Test("Positive zero is invertible")
    internal func positiveZeroIsInvertible() {
        #expect(Double.zero.isInvertible == true)
    }
}
