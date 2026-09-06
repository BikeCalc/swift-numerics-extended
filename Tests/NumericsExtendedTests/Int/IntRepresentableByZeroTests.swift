// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Int RepresentableByZero Tests")
internal struct IntRepresentableByZeroTests {
    @Test(
        "Nonzero values are not zero",
        arguments: [
            1,
            -1
        ]
    )
    internal func nonzeroValuesAreNotZero(value: Int) {
        #expect(value.isZero == false)
    }
}

// MARK: - Negative Zero

extension IntRepresentableByZeroTests {
    @Test("Negative zero is zero")
    internal func negativeZeroIsZero() {
        #expect(Int.negativeZero.isZero == true)
        #expect(Int.negativeZero == .zero)
    }
}

// MARK: - Positive Zero

extension IntRepresentableByZeroTests {
    @Test("Positive zero is zero")
    internal func positiveZeroIsZero() {
        #expect(Int.zero.isZero == true)
    }
}
