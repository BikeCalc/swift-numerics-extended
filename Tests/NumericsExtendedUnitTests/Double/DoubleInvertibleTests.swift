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

// MARK: - NaN

extension DoubleInvertibleTests {
    @Test("Reciprocal of NaN returns nil")
    internal func reciprocalOfNaNReturnsNil() {
        #expect(Double.nan.reciprocal == nil)
    }

    @Test("NaN is not invertible")
    internal func nanIsNotInvertible() {
        #expect(Double.nan.isInvertible == false)
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
    @Test("Reciprocal of negative zero returns nil")
    internal func reciprocalOfNegativeZeroReturnsNil() {
        #expect(Double.negativeZero.reciprocal == nil)
    }

    @Test("Negative zero is not invertible")
    internal func negativeZeroIsNotInvertible() {
        #expect(Double.negativeZero.isInvertible == false)
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
    @Test("Reciprocal of positive zero returns nil")
    internal func reciprocalOfPositiveZeroReturnsNil() {
        #expect(Double.zero.reciprocal == nil)
    }

    @Test("Positive zero is not invertible")
    internal func positiveZeroIsNotInvertible() {
        #expect(Double.zero.isInvertible == false)
    }
}
