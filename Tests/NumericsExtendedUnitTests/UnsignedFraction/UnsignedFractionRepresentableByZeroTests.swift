// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Unsigned Fraction RepresentableByZero Tests")
internal struct UnsignedFractionRepresentableByZeroTests {}

// MARK: - Negative Zero

extension UnsignedFractionRepresentableByZeroTests {
    @Test("Negative zero uses the positive zero representation")
    internal func negativeZeroUsesPositiveZeroRepresentation() {
        #expect(Fraction<UInt>.negativeZero.numerator == 0)
        #expect(Fraction<UInt>.negativeZero.denominator == 1)
    }
}
