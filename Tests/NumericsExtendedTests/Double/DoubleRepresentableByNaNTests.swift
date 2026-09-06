// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Double RepresentableByNaN Tests")
internal struct DoubleRepresentableByNaNTests {}

// MARK: - NaN

extension DoubleRepresentableByNaNTests {
    @Test("NaN is NaN")
    internal func nanIsNaN() {
        #expect(Double.nan.isNaN == true)
    }
}

// MARK: - Negative Infinity

extension DoubleRepresentableByNaNTests {
    @Test("Negative infinity is not NaN")
    internal func negativeInfinityIsNotNaN() {
        #expect(Double.negativeInfinity.isNaN == false)
    }
}

// MARK: - Negative Zero

extension DoubleRepresentableByNaNTests {
    @Test("Negative zero is not NaN")
    internal func negativeZeroIsNotNaN() {
        #expect(Double.negativeZero.isNaN == false)
    }
}

// MARK: - Positive Infinity

extension DoubleRepresentableByNaNTests {
    @Test("Positive infinity is not NaN")
    internal func positiveInfinityIsNotNaN() {
        #expect(Double.infinity.isNaN == false)
    }
}

// MARK: - Positive Zero

extension DoubleRepresentableByNaNTests {
    @Test("Positive zero is not NaN")
    internal func positiveZeroIsNotNaN() {
        #expect(Double.zero.isNaN == false)
    }
}
