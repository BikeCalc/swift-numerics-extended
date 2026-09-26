// This source file is part of the Numerics Extended open source project
//
// Copyright (c) 2021-2026 A. H. de Quatre Ltd. and the Numerics Extended project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.md for license information
// See CONTRIBUTORS.txt for the list of Numerics Extended project authors

import Testing

@testable import NumericsExtended

@Suite("Roman CustomDebugStringConvertible Tests")
internal struct RomanCustomDebugStringConvertibleTests {
    @Test(
        "Debug description succeeds",
        arguments: [
            (0, "Roman(0)"),
            (00, "Roman(0)"),
            (01, "Roman(1)"),
            (1, "Roman(1)")
        ] as Array<(Roman, String)>
    )
    internal func debugDescriptionSucceeds(
        value: Roman,
        debugDescription: String
    ) {
        #expect(value.debugDescription == debugDescription)
    }
}
