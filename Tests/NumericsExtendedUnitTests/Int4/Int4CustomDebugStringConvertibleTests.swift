// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Int4 CustomDebugStringConvertible Tests")
internal struct Int4CustomDebugStringConvertibleTests {
    @Test(
        "Debug description succeeds",
        arguments: [
            (-0, "Int4(0)"),
            (-00, "Int4(0)"),
            (-01, "Int4(-1)"),
            (-1, "Int4(-1)"),
            (0, "Int4(0)"),
            (00, "Int4(0)"),
            (01, "Int4(1)"),
            (1, "Int4(1)")
        ] as Array<(Int4, String)>
    )
    internal func debugDescriptionSucceeds(
        value: Int4,
        debugDescription: String
    ) {
        #expect(value.debugDescription == debugDescription)
    }
}
