// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Fraction CustomDebugStringConvertible Tests")
internal struct FractionCustomDebugStringConvertibleTests {
    internal init() {}

    @Test(
        "Debug description succeeds",
        arguments: [
            (.init(-01, 1), "Fraction<Int>(-1, 1)"),
            (.init(-1, 1), "Fraction<Int>(-1, 1)"),
            (.init(01, 1), "Fraction<Int>(1, 1)"),
            (.init(1, 1), "Fraction<Int>(1, 1)")
        ] as Array<(Fraction<Int>, String)>
    )
    internal func debugDescriptionSucceeds(
        value: Fraction<Int>,
        debugDescription: String
    ) {
        #expect(value.debugDescription == debugDescription)
    }
}

// MARK: - NaN

extension FractionCustomDebugStringConvertibleTests {
    @Test("NaN debug description")
    internal func nanDebugDescription() {
        #expect(Fraction<Int>.nan.debugDescription == "Fraction<Int>(0, 0)")
    }
}

// MARK: - Negative Infinity

extension FractionCustomDebugStringConvertibleTests {
    @Test("Negative infinity debug description")
    internal func negativeInfinityDebugDescription() {
        #expect(Fraction<Int>.negativeInfinity.debugDescription == "Fraction<Int>(-1, 0)")
    }
}

// MARK: - Negative Zero

extension FractionCustomDebugStringConvertibleTests {
    @Test(
        "Negative zero debug description",
        arguments: [
            (.negativeZero, "Fraction<Int>(0, -1)"),
            (.init(0, -2), "Fraction<Int>(0, -2)")
        ] as Array<(Fraction<Int>, String)>
    )
    internal func negativeZeroDebugDescription(
        value: Fraction<Int>,
        expected: String
    ) {
        #expect(value.debugDescription == expected)
    }
}

// MARK: - Positive Infinity

extension FractionCustomDebugStringConvertibleTests {
    @Test("Positive infinity debug description")
    internal func positiveInfinityDebugDescription() {
        #expect(Fraction<Int>.infinity.debugDescription == "Fraction<Int>(1, 0)")
    }
}

// MARK: - Positive Zero

extension FractionCustomDebugStringConvertibleTests {
    @Test(
        "Positive zero debug description",
        arguments: [
            (.zero, "Fraction<Int>(0, 1)"),
            (.init(0, 2), "Fraction<Int>(0, 2)")
        ] as Array<(Fraction<Int>, String)>
    )
    internal func positiveZeroDebugDescription(
        value: Fraction<Int>,
        expected: String
    ) {
        #expect(value.debugDescription == expected)
    }
}
