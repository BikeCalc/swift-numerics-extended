// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Roman Numeric Tests")
internal struct RomanNumericTests {
    @Test(
        "Initialized exactly succeeds",
        arguments: [
            (0, 0),
            (2, 2),
            (3, 3),
            (0, Roman.min),
            (3_999, Roman.max)
        ] as Array<(Int, Roman)>
    )
    internal func initializedExactlySucceeds(
        source: Int,
        value: Roman
    ) {
        #expect(Roman(exactly: source) == value)
    }

    @Test(
        "Initialized exactly fails",
        arguments: [
            -1,
            4_000
        ]
    )
    internal func initializedExactlyFails(source: Int) {
        #expect(Roman(exactly: source) == nil)
    }

    @Test(
        "Magnitude succeeds",
        arguments: [
            (0, 0),
            (2, 2),
            (3, 3),
            (Roman.min, Roman.min),
            (Roman.max, Roman.max)
        ] as Array<(Roman, Roman.Magnitude)>
    )
    internal func magnitudeSucceeds(
        value: Roman,
        magnitude: Roman.Magnitude
    ) {
        #expect(value.magnitude == magnitude)
    }
}
