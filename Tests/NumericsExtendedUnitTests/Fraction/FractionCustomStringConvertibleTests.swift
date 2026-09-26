// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Fraction CustomStringConvertible Tests")
internal struct FractionCustomStringConvertibleTests {
    @Test(
        "Description succeeds",
        arguments: [
            (Fraction<Int>(-01, 1), "-1/1"),
            (Fraction<Int>(-1, 1), "-1/1"),
            (Fraction<Int>(01, 1), "1/1"),
            (Fraction<Int>(1, 1), "1/1")
        ]
    )
    internal func descriptionSucceeds(
        value: Fraction<Int>,
        result: String
    ) {
        #expect(value.description == result)
    }
}

// MARK: - NaN

extension FractionCustomStringConvertibleTests {
    @Test("NaN description")
    internal func nanDescription() {
        #expect(Fraction<Int>.nan.description == "nan")
    }
}

// MARK: - Negative Infinity

extension FractionCustomStringConvertibleTests {
    @Test("Negative infinity description")
    internal func negativeInfinityDescription() {
        #expect(Fraction<Int>.negativeInfinity.description == "-inf")
    }
}

// MARK: - Negative Zero

extension FractionCustomStringConvertibleTests {
    @Test(
        "Negative zero description",
        arguments: [
            (Fraction<Int>.negativeZero, "0/-1"),
            (Fraction<Int>(0, -2), "0/-2")
        ]
    )
    internal func negativeZeroDescription(
        value: Fraction<Int>,
        result: String
    ) {
        #expect(value.description == result)
    }
}

// MARK: - Positive Infinity

extension FractionCustomStringConvertibleTests {
    @Test("Positive infinity description")
    internal func positiveInfinityDescription() {
        #expect(Fraction<Int>.infinity.description == "inf")
    }
}

// MARK: - Positive Zero

extension FractionCustomStringConvertibleTests {
    @Test(
        "Positive zero description",
        arguments: [
            (Fraction<Int>.zero, "0/1"),
            (Fraction<Int>(0, 2), "0/2")
        ]
    )
    internal func positiveZeroDescription(
        value: Fraction<Int>,
        result: String
    ) {
        #expect(value.description == result)
    }
}
