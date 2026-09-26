// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("UInt4 RepresentableByZero Tests")
internal struct UInt4RepresentableByZeroTests {
    @Test(
        "Nonzero values are not zero",
        arguments: [
            1,
            2
        ] as Array<UInt4>
    )
    internal func nonzeroValuesAreNotZero(value: UInt4) {
        #expect(value.isZero == false)
    }
}

// MARK: - Positive Zero

extension UInt4RepresentableByZeroTests {
    @Test("Positive zero is zero")
    internal func positiveZeroIsZero() {
        #expect(UInt4.zero.isZero == true)
    }
}
