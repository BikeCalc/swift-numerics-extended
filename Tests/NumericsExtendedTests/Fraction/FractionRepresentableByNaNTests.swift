// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Fraction RepresentableByNaN Tests")
internal struct FractionRepresentableByNaNTests {}

// MARK: - NaN

extension FractionRepresentableByNaNTests {
    @Test("NaN is NaN")
    internal func nanIsNaN() {
        #expect(Fraction<Int>.nan.isNaN == true)
        #expect(Fraction<Int>(0, 0).isNaN == true)
    }
}

// MARK: - Negative Infinity

extension FractionRepresentableByNaNTests {
    @Test("Negative infinity is not NaN")
    internal func negativeInfinityIsNotNaN() {
        #expect(Fraction<Int>.negativeInfinity.isNaN == false)
    }
}

// MARK: - Negative Zero

extension FractionRepresentableByNaNTests {
    @Test("Negative zero is not NaN")
    internal func negativeZeroIsNotNaN() {
        #expect(Fraction<Int>.negativeZero.isNaN == false)
    }
}

// MARK: - Positive Infinity

extension FractionRepresentableByNaNTests {
    @Test("Positive infinity is not NaN")
    internal func positiveInfinityIsNotNaN() {
        #expect(Fraction<Int>.infinity.isNaN == false)
    }
}

// MARK: - Positive Zero

extension FractionRepresentableByNaNTests {
    @Test("Positive zero is not NaN")
    internal func positiveZeroIsNotNaN() {
        #expect(Fraction<Int>.zero.isNaN == false)
    }
}
