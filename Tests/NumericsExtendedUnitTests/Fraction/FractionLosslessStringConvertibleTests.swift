// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Fraction LosslessStringConvertible Tests")
internal struct FractionLosslessStringConvertibleTests {
    internal init() {}

    @Test(
        "String initialization succeeds",
        arguments: [
            ("2", Fraction<Int>(2, 1)),
            ("1/2", Fraction<Int>(1, 2)),
            ("2/4", Fraction<Int>(2, 4)),
            ("2/-4", Fraction<Int>(2, -4))
        ]
    )
    internal func stringInitializationSucceeds(
        description: String,
        value: Fraction<Int>
    ) {
        let result: Fraction<Int>? = Fraction<Int>(description)
        #expect(result == value)
    }

    @Test(
        "String initialization fails",
        arguments: [
            "",
            "/",
            "1/",
            "/2",
            "1/2/3",
            "abc",
            "1.5"
        ]
    )
    internal func stringInitializationFails(description: String) {
        let result: Fraction<Int>? = Fraction<Int>(description)
        #expect(result == nil)
    }
}

// MARK: - Negative Infinity

extension FractionLosslessStringConvertibleTests {
    @Test(
        "Negative infinity string initialization succeeds",
        arguments: [
            "-inf",
            "-infinity"
        ]
    )
    internal func negativeInfinityStringInitializationSucceeds(description: String) {
        let result: Fraction<Int>? = Fraction<Int>(description)
        #expect(result == .negativeInfinity)
    }
}

// MARK: - Negative NaN

extension FractionLosslessStringConvertibleTests {
    @Test("Negative NaN string initialization succeeds")
    internal func negativeNanStringInitializationSucceeds() {
        let description: String = "-nan"
        let result: Fraction<Int>? = Fraction<Int>(description)
        #expect(result?.isNaN == true)
    }
}

// MARK: - Negative Zero

extension FractionLosslessStringConvertibleTests {
    @Test(
        "Negative zero string initialization succeeds",
        arguments: [
            ("-0", Fraction<Int>(0, -1)),
            ("0/-1", Fraction<Int>(0, -1)),
            ("0/-2", Fraction<Int>(0, -2))
        ]
    )
    internal func negativeZeroStringInitializationSucceeds(
        description: String,
        value: Fraction<Int>
    ) {
        let result: Fraction<Int>? = Fraction<Int>(description)
        #expect(result == value)
    }
}

// MARK: - Positive Infinity

extension FractionLosslessStringConvertibleTests {
    @Test(
        "Positive infinity string initialization succeeds",
        arguments: [
            "inf",
            "+inf",
            "infinity",
            "+infinity"
        ]
    )
    internal func positiveInfinityStringInitializationSucceeds(description: String) {
        let result: Fraction<Int>? = Fraction<Int>(description)
        #expect(result == .infinity)
    }
}

// MARK: - Positive NaN

extension FractionLosslessStringConvertibleTests {
    @Test(
        "Positive NaN string initialization succeeds",
        arguments: [
            "nan",
            "+nan"
        ]
    )
    internal func positiveNanStringInitializationSucceeds(description: String) {
        let result: Fraction<Int>? = Fraction<Int>(description)
        #expect(result?.isNaN == true)
    }
}

// MARK: - Positive Zero

extension FractionLosslessStringConvertibleTests {
    @Test(
        "Positive zero string initialization succeeds",
        arguments: [
            ("0", Fraction<Int>(0, 1)),
            ("0/1", Fraction<Int>(0, 1)),
            ("0/2", Fraction<Int>(0, 2))
        ]
    )
    internal func positiveZeroStringInitializationSucceeds(
        description: String,
        value: Fraction<Int>
    ) {
        let result: Fraction<Int>? = Fraction<Int>(description)
        #expect(result == value)
    }
}
