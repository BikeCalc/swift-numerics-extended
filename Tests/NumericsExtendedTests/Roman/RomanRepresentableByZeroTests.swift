// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Roman RepresentableByZero Tests")
internal struct RomanRepresentableByZeroTests {
    @Test(
        "Nonzero values are not zero",
        arguments: [
            1,
            2
        ] as Array<Roman>
    )
    internal func nonzeroValuesAreNotZero(value: Roman) {
        #expect(value.isZero == false)
    }
}

// MARK: - Positive Zero

extension RomanRepresentableByZeroTests {
    @Test("Positive zero is zero")
    internal func positiveZeroIsZero() {
        #expect(Roman.zero.isZero == true)
    }
}
