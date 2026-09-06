// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Int4 Numeric Tests")
internal struct Int4NumericTests {
    @Test(
        "Initialized exactly succeeds",
        arguments: [
            (0, 0),
            (2, 2),
            (3, 3),
            (-2, -2),
            (-3, -3),
            (-8, Int4.min),
            (7, Int4.max)
        ] as Array<(Int, Int4)>
    )
    internal func initializedExactlySucceeds(
        source: Int,
        value: Int4
    ) {
        #expect(Int4(exactly: source) == value)
    }

    @Test(
        "Initialized exactly fails",
        arguments: [
            -9,
            8
        ]
    )
    internal func initializedExactlyFails(source: Int) {
        #expect(Int4(exactly: source) == nil)
    }

    @Test(
        "Magnitude succeeds",
        arguments: [
            (0, 0),
            (2, 2),
            (3, 3),
            (-2, 2),
            (-3, 3),
            (Int4.min, 8),
            (Int4.max, 7)
        ] as Array<(Int4, UInt4)>
    )
    internal func magnitudeSucceeds(
        value: Int4,
        magnitude: UInt4
    ) {
        #expect(value.magnitude == magnitude)
    }
}
