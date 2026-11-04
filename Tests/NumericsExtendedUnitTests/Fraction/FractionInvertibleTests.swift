// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Fraction Invertible Tests")
internal struct FractionInvertibleTests {
    internal init() {}

    @Test(
        "Reciprocal",
        arguments: [
            (.init(1, 1), Fraction<Int>(1, 1) as Fraction<Int>?),
            (.init(-1, 1), Fraction<Int>(1, -1)),
            (.init(2, 1), Fraction<Int>(1, 2)),
            (.init(-2, 1), Fraction<Int>(1, -2))
        ] as Array<(Fraction<Int>, Fraction<Int>.Reciprocal?)>
    )
    internal func reciprocal(
        dividend: Fraction<Int>,
        expected: Fraction<Int>.Reciprocal?
    ) {
        #expect(dividend.reciprocal == expected)
    }

    @Test(
        "Is invertible",
        arguments: [
            .init(2, 1),
            .init(3, 1),
            .init(-2, 1),
            .init(-3, 1)
        ] as Array<Fraction<Int>>
    )
    internal func isInvertible(dividend: Fraction<Int>) {
        let result: Bool = dividend.isInvertible
        #expect(result == true)
    }
}

// MARK: - NaN

extension FractionInvertibleTests {
    @Test("Reciprocal of NaN returns nil")
    internal func reciprocalOfNaNReturnsNil() {
        #expect(Fraction<Int>.nan.reciprocal == nil)
    }

    @Test("NaN is not invertible")
    internal func nanIsNotInvertible() {
        #expect(Fraction<Int>.nan.isInvertible == false)
    }
}

// MARK: - Negative Infinity

extension FractionInvertibleTests {
    @Test("Reciprocal of negative infinity returns negative zero")
    internal func reciprocalOfNegativeInfinityReturnsNegativeZero() {
        #expect(Fraction<Int>.negativeInfinity.reciprocal == Fraction<Int>.negativeZero)
    }

    @Test("Negative infinity is invertible")
    internal func negativeInfinityIsInvertible() {
        #expect(Fraction<Int>.negativeInfinity.isInvertible == true)
    }
}

// MARK: - Negative Zero

extension FractionInvertibleTests {
    @Test("Reciprocal of negative zero returns nil")
    internal func reciprocalOfNegativeZeroReturnsNil() {
        #expect(Fraction<Int>.negativeZero.reciprocal == nil)
    }

    @Test("Negative zero is not invertible")
    internal func negativeZeroIsNotInvertible() {
        #expect(Fraction<Int>.negativeZero.isInvertible == false)
    }
}

// MARK: - Positive Infinity

extension FractionInvertibleTests {
    @Test("Reciprocal of positive infinity returns positive zero")
    internal func reciprocalOfPositiveInfinityReturnsPositiveZero() {
        #expect(Fraction<Int>.infinity.reciprocal == Fraction<Int>.zero)
    }

    @Test("Positive infinity is invertible")
    internal func positiveInfinityIsInvertible() {
        #expect(Fraction<Int>.infinity.isInvertible == true)
    }
}

// MARK: - Positive Zero

extension FractionInvertibleTests {
    @Test("Reciprocal of positive zero returns nil")
    internal func reciprocalOfPositiveZeroReturnsNil() {
        #expect(Fraction<Int>.zero.reciprocal == nil)
    }

    @Test("Positive zero is not invertible")
    internal func positiveZeroIsNotInvertible() {
        #expect(Fraction<Int>.zero.isInvertible == false)
    }
}
