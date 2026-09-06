// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Fraction RepresentableByZero Tests")
internal struct FractionRepresentableByZeroTests {
    @Test(
        "Nonzero values are not zero",
        arguments: [
            Fraction<Int>(1, 1),
            Fraction<Int>(-1, 1)
        ]
    )
    internal func nonzeroValuesAreNotZero(value: Fraction<Int>) {
        #expect(value.isZero == false)
    }
}

// MARK: - Negative Zero

extension FractionRepresentableByZeroTests {
    @Test("Negative zero is zero")
    internal func negativeZeroIsZero() {
        #expect(Fraction<Int>.negativeZero.numerator == 0)
        #expect(Fraction<Int>.negativeZero.denominator == -1)
        #expect(Fraction<Int>.negativeZero.isZero == true)
        #expect(Fraction<Int>.negativeZero != .zero)
    }

    @Test("Stored negative-zero representation is zero")
    internal func storedNegativeZeroRepresentationIsZero() {
        #expect(Fraction<Int>(0, -2).isZero == true)
    }
}

// MARK: - Positive Zero

extension FractionRepresentableByZeroTests {
    @Test("Positive zero is zero")
    internal func positiveZeroIsZero() {
        #expect(Fraction<Int>.zero.numerator == 0)
        #expect(Fraction<Int>.zero.denominator == 1)
        #expect(Fraction<Int>.zero.isZero == true)
    }

    @Test("Stored positive-zero representation is zero")
    internal func storedPositiveZeroRepresentationIsZero() {
        #expect(Fraction<Int>(0, 2).isZero == true)
    }
}
