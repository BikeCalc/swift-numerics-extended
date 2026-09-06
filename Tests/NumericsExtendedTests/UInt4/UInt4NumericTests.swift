// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("UInt4 Numeric Tests")
internal struct UInt4NumericTests {
    @Test(
        "Initialized exactly succeeds",
        arguments: [
            (0, 0),
            (2, 2),
            (3, 3),
            (0, UInt4.min),
            (15, UInt4.max)
        ] as Array<(Int, UInt4)>
    )
    internal func initializedExactlySucceeds(
        source: Int,
        value: UInt4
    ) {
        #expect(UInt4(exactly: source) == value)
    }

    @Test(
        "Initialized exactly fails",
        arguments: [
            -1,
            16
        ]
    )
    internal func initializedExactlyFails(source: Int) {
        #expect(UInt4(exactly: source) == nil)
    }

    @Test(
        "Magnitude succeeds",
        arguments: [
            (0, 0),
            (2, 2),
            (3, 3),
            (UInt4.min, UInt4.min),
            (UInt4.max, UInt4.max)
        ] as Array<(UInt4, UInt4.Magnitude)>
    )
    internal func magnitudeSucceeds(
        value: UInt4,
        magnitude: UInt4.Magnitude
    ) {
        #expect(value.magnitude == magnitude)
    }
}
