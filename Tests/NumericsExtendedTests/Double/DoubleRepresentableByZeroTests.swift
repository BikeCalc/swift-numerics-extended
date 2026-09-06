// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Double RepresentableByZero Tests")
internal struct DoubleRepresentableByZeroTests {
    @Test(
        "Nonzero values are not zero",
        arguments: [
            1.0,
            -1.0,
            0.5,
            -0.5
        ]
    )
    internal func nonzeroValuesAreNotZero(value: Double) {
        #expect(value.isZero == false)
    }
}

// MARK: - Negative Zero

extension DoubleRepresentableByZeroTests {
    @Test("Negative zero is zero")
    internal func negativeZeroIsZero() {
        #expect(Double.negativeZero.isZero == true)
        #expect(Double.negativeZero.sign == .minus)
    }
}

// MARK: - Positive Zero

extension DoubleRepresentableByZeroTests {
    @Test("Positive zero is zero")
    internal func positiveZeroIsZero() {
        #expect(Double.zero.isZero == true)
        #expect(Double.zero.sign == .plus)
    }
}
