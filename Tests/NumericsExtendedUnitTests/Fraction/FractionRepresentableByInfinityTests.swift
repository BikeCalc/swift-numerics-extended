// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Fraction RepresentableByInfinity Tests")
internal struct FractionRepresentableByInfinityTests {
    @Test(
        "Finite values are finite",
        arguments: [
            Fraction<Int>(1, 2),
            Fraction<Int>(-1, 2),
            Fraction<Int>(-1, -2),
            Fraction<Int>(1, -2)
        ]
    )
    internal func finiteValuesAreFinite(value: Fraction<Int>) {
        #expect(value.isFinite == true)
        #expect(value.isInfinite == false)
    }
}

// MARK: - NaN

extension FractionRepresentableByInfinityTests {
    @Test("NaN is neither finite nor infinite")
    internal func nanIsNeitherFiniteNorInfinite() {
        #expect(Fraction<Int>.nan.isFinite == false)
        #expect(Fraction<Int>.nan.isInfinite == false)
    }
}

// MARK: - Negative Infinity

extension FractionRepresentableByInfinityTests {
    @Test("Negative infinity is infinite")
    internal func negativeInfinityIsInfinite() {
        #expect(Fraction<Int>.negativeInfinity.isFinite == false)
        #expect(Fraction<Int>.negativeInfinity.isInfinite == true)
        #expect(Fraction<Int>(-1, 0).isInfinite == true)
    }

    @Test("Negative infinity equals negated infinity")
    internal func negativeInfinityEqualsNegatedInfinity() {
        #expect(Fraction<Int>.negativeInfinity == -Fraction<Int>.infinity)
    }
}

// MARK: - Negative Zero

extension FractionRepresentableByInfinityTests {
    @Test("Negative zero is finite")
    internal func negativeZeroIsFinite() {
        #expect(Fraction<Int>.negativeZero.isFinite == true)
        #expect(Fraction<Int>.negativeZero.isInfinite == false)
    }
}

// MARK: - Positive Infinity

extension FractionRepresentableByInfinityTests {
    @Test("Positive infinity is infinite")
    internal func positiveInfinityIsInfinite() {
        #expect(Fraction<Int>.infinity.isFinite == false)
        #expect(Fraction<Int>.infinity.isInfinite == true)
        #expect(Fraction<Int>(1, 0).isInfinite == true)
    }
}

// MARK: - Positive Zero

extension FractionRepresentableByInfinityTests {
    @Test("Positive zero is finite")
    internal func positiveZeroIsFinite() {
        #expect(Fraction<Int>.zero.isFinite == true)
        #expect(Fraction<Int>.zero.isInfinite == false)
    }
}
