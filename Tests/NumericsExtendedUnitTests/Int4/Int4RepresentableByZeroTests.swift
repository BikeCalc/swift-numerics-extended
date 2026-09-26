// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Int4 RepresentableByZero Tests")
internal struct Int4RepresentableByZeroTests {
    @Test(
        "Nonzero values are not zero",
        arguments: [
            1,
            -1
        ] as Array<Int4>
    )
    internal func nonzeroValuesAreNotZero(value: Int4) {
        #expect(value.isZero == false)
    }
}

// MARK: - Negative Zero

extension Int4RepresentableByZeroTests {
    @Test("Negative zero is zero")
    internal func negativeZeroIsZero() {
        #expect(Int4.negativeZero.isZero == true)
        #expect(Int4.negativeZero == .zero)
    }
}

// MARK: - Positive Zero

extension Int4RepresentableByZeroTests {
    @Test("Positive zero is zero")
    internal func positiveZeroIsZero() {
        #expect(Int4.zero.isZero == true)
    }
}
