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
    internal init() {}

    @Test(
        "Description succeeds",
        arguments: [
            (.init(-01, 1), "-1/1"),
            (.init(-1, 1), "-1/1"),
            (.init(01, 1), "1/1"),
            (.init(1, 1), "1/1")
        ] as Array<(Fraction<Int>, String)>
    )
    internal func descriptionSucceeds(
        value: Fraction<Int>,
        expected: String
    ) {
        #expect(value.description == expected)
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
            (.negativeZero, "0/-1"),
            (.init(0, -2), "0/-2")
        ] as Array<(Fraction<Int>, String)>
    )
    internal func negativeZeroDescription(
        value: Fraction<Int>,
        expected: String
    ) {
        #expect(value.description == expected)
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
            (.zero, "0/1"),
            (.init(0, 2), "0/2")
        ] as Array<(Fraction<Int>, String)>
    )
    internal func positiveZeroDescription(
        value: Fraction<Int>,
        expected: String
    ) {
        #expect(value.description == expected)
    }
}
