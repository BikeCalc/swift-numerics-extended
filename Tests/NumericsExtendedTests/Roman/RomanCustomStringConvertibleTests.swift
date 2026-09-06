// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Roman CustomStringConvertible Tests")
internal struct RomanCustomStringConvertibleTests {
    @Test(
        "Description succeeds",
        arguments: [
            (0, "N"),
            (00, "N"),
            (01, "I"),
            (1, "I"),
            (3, "III"),
            (4, "IV"),
            (9, "IX"),
            (16, "XVI"),
            (44, "XLIV"),
            (90, "XC"),
            (400, "CD"),
            (900, "CM"),
            (3_999, "MMMCMXCIX")
        ] as Array<(Roman, String)>
    )
    internal func descriptionSucceeds(
        value: Roman,
        description: String
    ) {
        #expect(value.description == description)
    }
}
