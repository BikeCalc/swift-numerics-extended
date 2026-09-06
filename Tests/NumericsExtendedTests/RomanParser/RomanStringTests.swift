// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Roman String Tests")
internal struct RomanStringTests {
    @Test(
        "Is Roman symbol",
        arguments: [
            ("", false),
            ("N", true),
            ("I", true),
            ("IV", true),
            ("V", true),
            ("IX", true),
            ("X", true),
            ("XL", true),
            ("L", true),
            ("XC", true),
            ("C", true),
            ("CD", true),
            ("D", true),
            ("CM", true),
            ("M", true),
            ("II", false),
            ("VI", false),
            ("MMM", false),
            ("A", false),
            ("z", false)
        ]
    )
    internal func isRomanSymbol(
        string: String,
        result: Bool
    ) {
        #expect(string.isRomanSymbol == result)
    }

    @Test(
        "Is Roman numeral",
        arguments: [
            ("", false),
            ("N", true),
            ("I", true),
            ("II", true),
            ("III", true),
            ("IV", true),
            ("V", true),
            ("VI", true),
            ("VIII", true),
            ("IX", true),
            ("X", true),
            ("XX", true),
            ("XXX", true),
            ("XIV", true),
            ("XVI", true),
            ("XL", true),
            ("XLIV", true),
            ("L", true),
            ("XC", true),
            ("C", true),
            ("CC", true),
            ("CCC", true),
            ("CD", true),
            ("D", true),
            ("CM", true),
            ("M", true),
            ("MM", true),
            ("MMM", true),
            ("CMXCIX", true),
            ("MMXXVI", true),
            ("MMMCMXCIX", true),
            ("IN", false),
            ("NI", false),
            ("NN", false),
            ("IIII", false),
            ("VV", false),
            ("XXXX", false),
            ("LL", false),
            ("CCCC", false),
            ("DD", false),
            ("MMMM", false),
            ("IVIV", false),
            ("IIV", false),
            ("IXI", false),
            ("IXX", false),
            ("VIIII", false),
            ("VX", false),
            ("IC", false),
            ("IL", false),
            ("XXC", false),
            ("XD", false),
            ("XM", false),
            ("CCD", false),
            ("CMC", false),
            ("MCMC", false),
            ("XIXI", false),
            (" ", false),
            ("IV ", false),
            (" IV", false),
            ("ABC", false),
            ("iv", false)
        ]
    )
    internal func isRomanNumeral(
        string: String,
        result: Bool
    ) {
        #expect(string.isRomanNumeral == result)
    }
}
