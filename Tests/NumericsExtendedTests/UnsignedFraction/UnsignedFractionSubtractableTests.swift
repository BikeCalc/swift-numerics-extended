// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Unsigned Fraction Subtractable Tests")
internal struct UnsignedFractionSubtractableTests {}

// MARK: - NaN

extension UnsignedFractionSubtractableTests {
    @Test(
        "Subtracting positive infinity returns NaN when negative infinity is unrepresentable",
        arguments: [
            Fraction<UInt>.zero,
            Fraction<UInt>(1, 2),
            Fraction<UInt>(2, 1)
        ]
    )
    internal func subtractingPositiveInfinityReturnsNan(minuend: Fraction<UInt>) {
        #expect((minuend - .infinity).isNaN == true)
    }
}
