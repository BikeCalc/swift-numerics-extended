// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Unsigned Fraction LosslessStringConvertible Tests")
internal struct UnsignedFractionLosslessStringConvertibleTests {
    @Test(
        "Negative finite string initialization fails",
        arguments: [
            "-1",
            "-1/2",
            "1/-2"
        ]
    )
    internal func negativeFiniteStringInitializationFails(description: String) {
        #expect(Fraction<UInt>(description) == nil)
    }
}

// MARK: - Negative Infinity

extension UnsignedFractionLosslessStringConvertibleTests {
    @Test(
        "Negative infinity string initialization fails",
        arguments: [
            "-inf",
            "-infinity"
        ]
    )
    internal func negativeInfinityStringInitializationFails(description: String) {
        #expect(Fraction<UInt>(description) == nil)
    }
}

// MARK: - Negative NaN

extension UnsignedFractionLosslessStringConvertibleTests {
    @Test("Negative NaN string initialization fails")
    internal func negativeNanStringInitializationFails() {
        #expect(Fraction<UInt>("-nan") == nil)
    }
}

// MARK: - Negative Zero

extension UnsignedFractionLosslessStringConvertibleTests {
    @Test(
        "Negative zero string initialization fails",
        arguments: [
            "-0",
            "0/-1"
        ]
    )
    internal func negativeZeroStringInitializationFails(description: String) {
        #expect(Fraction<UInt>(description) == nil)
    }
}
