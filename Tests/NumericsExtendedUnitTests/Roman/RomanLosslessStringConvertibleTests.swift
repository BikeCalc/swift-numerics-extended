// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Roman LosslessStringConvertible Tests")
internal struct RomanLosslessStringConvertibleTests {
    @Test(
        "Decimal String initialization succeeds",
        arguments: [
            ("01", 1),
            ("1", 1),
            ("3999", 3_999)
        ] as Array<(String, Roman)>
    )
    internal func decimalStringInitializationSucceeds(
        description: String,
        value: Roman
    ) {
        #expect(Roman(description) == value)
    }

    @Test(
        "String initialization succeeds",
        arguments: [
            ("I", 1),
            ("III", 3),
            ("IV", 4),
            ("IX", 9),
            ("XXX", 30),
            ("XVI", 16),
            ("XLIV", 44),
            ("XC", 90),
            ("CCC", 300),
            ("CD", 400),
            ("CM", 900),
            ("MMM", 3_000),
            ("MMMCMXCIX", 3_999)
        ] as Array<(String, Roman)>
    )
    internal func stringInitializationSucceeds(
        description: String,
        value: Roman
    ) {
        #expect(Roman(description) == value)
    }

    @Test(
        "String initialization fails",
        arguments: [
            "",
            "-1",
            "4000",
            "IN",
            "NI",
            "NN",
            "IIII",
            "VV",
            "XXXX",
            "LL",
            "CCCC",
            "DD",
            "MMMM",
            "IVIV",
            "IIV",
            "IXI",
            "VIIII",
            "VX",
            "IC",
            "IL",
            "XD",
            "XM",
            "MCMC",
            "ABC",
            "iv"
        ]
    )
    internal func stringInitializationFails(description: String) {
        #expect(Roman(description) == nil)
    }
}

// MARK: - Positive Zero

extension RomanLosslessStringConvertibleTests {
    @Test(
        "Positive zero decimal string initialization succeeds",
        arguments: [
            "0",
            "00"
        ]
    )
    internal func positiveZeroDecimalStringInitializationSucceeds(description: String) {
        #expect(Roman(description) == .zero)
    }

    @Test("Positive zero Roman numeral string initialization succeeds")
    internal func positiveZeroRomanNumeralStringInitializationSucceeds() {
        #expect(Roman("N") == .zero)
    }
}
